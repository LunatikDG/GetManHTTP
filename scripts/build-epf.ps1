# Build external data processor (.epf) from EDT project sources.
# Requires 1C:EDT CLI (1cedtcli) and 1C:Enterprise platform (1cv8 DESIGNER).
#
# Usage (from project root):
#   .\scripts\build-epf.ps1
#   .\scripts\build-epf.ps1 -OutputEpf "bin\GetManHTTP.epf"
#
# Optional env:
#   ONEC_V8_EXE      - full path to 1cv8.exe
#   ONEC_V8_VERSION  - prefer platform folder (default: Runtime-Version from DT-INF/PROJECT.PMF)
#   ONEC_EDT_CLI     - full path to 1cedtcli.exe
#   ONEC_EDT_VERSION - prefer this EDT in path (default: 2025.1, see release.yml EDT_VERSION)
#   ONEC_EDT_DATA    - existing EDT workspace (-data); export uses --project-name (faster locally)
#   ONEC_PROCESSOR   - metadata name (default: GetManHTTP)

#Requires -Version 5.1
param(
	[string]$OutputEpf = "",

	[string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,

	[string]$ProcessorName = $(if ($env:ONEC_PROCESSOR) { $env:ONEC_PROCESSOR } else { "GetManHTTP" })
)

$ErrorActionPreference = "Stop"

function Escape-ProcessArgument([string]$Argument) {
	if ($null -eq $Argument) {
		return '""'
	}
	if ($Argument.Length -eq 0) {
		return '""'
	}
	if ($Argument -notmatch '[\s"]') {
		return $Argument
	}
	$sb = New-Object System.Text.StringBuilder
	[void]$sb.Append('"')
	$backslashCount = 0
	foreach ($c in $Argument.ToCharArray()) {
		if ($c -eq '\') {
			$backslashCount++
			continue
		}
		if ($c -eq '"') {
			[void]$sb.Append(('\' * (($backslashCount * 2) + 1)))
			[void]$sb.Append('"')
			$backslashCount = 0
			continue
		}
		if ($backslashCount -gt 0) {
			[void]$sb.Append(('\' * $backslashCount))
			$backslashCount = 0
		}
		[void]$sb.Append($c)
	}
	if ($backslashCount -gt 0) {
		[void]$sb.Append(('\' * ($backslashCount * 2)))
	}
	[void]$sb.Append('"')
	return $sb.ToString()
}

function Get-ProjectRuntimeVersion {
	param([string]$ProjectRoot)

	$pmfPath = Join-Path $ProjectRoot "DT-INF\PROJECT.PMF"
	if (-not (Test-Path -LiteralPath $pmfPath)) {
		return "8.3.27"
	}
	foreach ($line in Get-Content -LiteralPath $pmfPath -Encoding UTF8) {
		if ($line -match '^Runtime-Version:\s*(.+)\s*$') {
			return $matches[1].Trim()
		}
	}
	return "8.3.27"
}

function Find-OneCPlatformExe {
	param([string]$PreferredVersion)

	if ($env:ONEC_V8_EXE -and (Test-Path -LiteralPath $env:ONEC_V8_EXE)) {
		return (Resolve-Path -LiteralPath $env:ONEC_V8_EXE).Path
	}
	$candidates = @(
		Get-ChildItem -Path "${env:ProgramFiles(x86)}\1cv8\*\bin\1cv8.exe" -ErrorAction SilentlyContinue
		Get-ChildItem -Path "$env:ProgramFiles\1cv8\*\bin\1cv8.exe" -ErrorAction SilentlyContinue
	)
	if ($candidates.Count -eq 0) {
		throw "1cv8.exe not found. Install 1C:Enterprise $PreferredVersion or set ONEC_V8_EXE."
	}
	$versionPattern = [regex]::Escape($PreferredVersion)
	$matched = $candidates | Where-Object { $_.FullName -match "\\1cv8\\$versionPattern" } | Sort-Object FullName -Descending
	if ($matched.Count -gt 0) {
		return $matched[0].FullName
	}
	$fallback = $candidates | Sort-Object FullName -Descending | Select-Object -First 1
	Write-Warning "Platform $PreferredVersion not found; using $($fallback.FullName). Set ONEC_V8_EXE or ONEC_V8_VERSION."
	return $fallback.FullName
}

function Find-EdtCli {
	if ($env:ONEC_EDT_CLI -and (Test-Path -LiteralPath $env:ONEC_EDT_CLI)) {
		return (Resolve-Path -LiteralPath $env:ONEC_EDT_CLI).Path
	}
	$preferredVersion = if (-not [string]::IsNullOrWhiteSpace($env:ONEC_EDT_VERSION)) {
		$env:ONEC_EDT_VERSION
	} else {
		"2025.1"
	}
	$searchRoots = @(
		"$env:ProgramFiles\1C\1CE\components"
		"$env:LOCALAPPDATA\1C\1cedtstart\installations"
	)
	$candidates = @()
	foreach ($root in $searchRoots) {
		if (Test-Path -LiteralPath $root) {
			$candidates += Get-ChildItem -Path $root -Recurse -Filter "1cedtcli.exe" -ErrorAction SilentlyContinue
		}
	}
	if ($candidates.Count -eq 0) {
		throw "1cedtcli.exe not found. Install 1C:EDT $preferredVersion (see .github/workflows/release.yml) or set ONEC_EDT_CLI."
	}
	$preferred = $candidates | Where-Object { $_.FullName -like "*$preferredVersion*" } | Sort-Object FullName -Descending
	if ($preferred.Count -gt 0) {
		return $preferred[0].FullName
	}
	$fallback = $candidates | Sort-Object FullName -Descending | Select-Object -First 1
	Write-Warning "EDT $preferredVersion not found; using $($fallback.FullName). For CI parity install EDT $preferredVersion or set ONEC_EDT_CLI."
	return $fallback.FullName
}

function Invoke-EdtCli([string]$FilePath, [string[]]$Arguments, [string]$LogFilePath) {
	Write-Host "> $FilePath $($Arguments -join ' ')"
	$output = & $FilePath @Arguments 2>&1
	$output | ForEach-Object { Write-Host $_ }
	if (-not [string]::IsNullOrWhiteSpace($LogFilePath)) {
		$output | Out-File -LiteralPath $LogFilePath -Append -Encoding UTF8
	}
	if ($LASTEXITCODE -ne 0) {
		$logHint = ""
		if (-not [string]::IsNullOrWhiteSpace($LogFilePath) -and (Test-Path -LiteralPath $LogFilePath)) {
			$logHint = " See log: $LogFilePath"
		}
		throw "1cedtcli failed with exit code $LASTEXITCODE.$logHint"
	}
}

function Invoke-Platform([string]$FilePath, [string[]]$Arguments) {
	$argumentLine = ($Arguments | ForEach-Object { Escape-ProcessArgument $_ }) -join ' '
	Write-Host "> $FilePath $argumentLine"
	$psi = New-Object System.Diagnostics.ProcessStartInfo
	$psi.FileName = $FilePath
	$psi.Arguments = $argumentLine
	$psi.UseShellExecute = $false
	$process = [System.Diagnostics.Process]::Start($psi)
	if (-not $process.WaitForExit(3900000)) {
		$process.Kill()
		throw "Command timed out after 3600s : $FilePath"
	}
	if ($process.ExitCode -ne 0) {
		throw "Command failed with exit code $($process.ExitCode) : $FilePath"
	}
}

# 1cedtcli splits --project on spaces; junction breaks import ("not correctly started") — stage a copy.
function New-EdtProjectPathAlias {
	param(
		[string]$ProjectRoot,
		[string]$ParentDirectory,
		[string]$EdtProjectName
	)
	$resolved = (Resolve-Path -LiteralPath $ProjectRoot).Path
	if ($resolved -notmatch '\s') {
		return @{ Path = $resolved }
	}

	$stagingPath = Join-Path $ParentDirectory $EdtProjectName
	Write-Host "Project path contains spaces; staging copy for EDT CLI:"
	Write-Host "  $stagingPath"
	if (Test-Path -LiteralPath $stagingPath) {
		Remove-Item -LiteralPath $stagingPath -Recurse -Force -ErrorAction SilentlyContinue
	}
	$null = New-Item -ItemType Directory -Force -Path $stagingPath
	$robocopyArgs = @(
		$resolved,
		$stagingPath,
		"/E",
		"/XD", ".git",
		"/NFL", "/NDL", "/NJH", "/NJS", "/nc", "/ns", "/np"
	)
	& robocopy @robocopyArgs | Out-Null
	if ($LASTEXITCODE -ge 8) {
		throw "Failed to stage EDT project (robocopy exit code $LASTEXITCODE)"
	}

	return @{ Path = $stagingPath }
}

function Get-EdtProjectName([string]$ProjectRoot) {
	$projectFile = Join-Path $ProjectRoot ".project"
	if (-not (Test-Path -LiteralPath $projectFile)) {
		throw "EDT project file not found: $projectFile"
	}
	[xml]$projectXml = Get-Content -LiteralPath $projectFile -Encoding UTF8
	return [string]$projectXml.projectDescription.name
}

function Resolve-EdtWorkspace {
	param([string]$ProjectRoot)

	if (-not [string]::IsNullOrWhiteSpace($env:ONEC_EDT_DATA) -and (Test-Path -LiteralPath $env:ONEC_EDT_DATA)) {
		return @{
			Path = (Resolve-Path -LiteralPath $env:ONEC_EDT_DATA).Path
			UseExisting = $true
		}
	}

	$parentDir = (Resolve-Path (Join-Path $ProjectRoot "..")).Path
	$metadataDir = Join-Path $parentDir ".metadata"
	if (Test-Path -LiteralPath $metadataDir) {
		Write-Host "Detected EDT workspace at: $parentDir"
		return @{ Path = $parentDir; UseExisting = $true }
	}

	return @{ Path = $null; UseExisting = $false }
}

function Export-EdtProjectToDesignerXml {
	param(
		[string]$EdtCli,
		[string]$WorkspacePath,
		[string]$EdtProjectPath,
		[string]$EdtProjectName,
		[string]$ExportPath,
		[string]$LogFilePath,
		[int]$TimeoutSec,
		[bool]$UseExistingWorkspace
	)

	$exportArgs = @(
		"-data", $WorkspacePath,
		"-timeout", "$TimeoutSec",
		"-command", "export",
		"--configuration-files", $ExportPath
	)

	if ($UseExistingWorkspace) {
		# Always pass --project with the on-disk path so Form.form / Module.bsl
		# edits made outside EDT (e.g. in Cursor) are picked up. --project-name
		# alone can export a stale in-memory form model from the workspace.
		Write-Host "Exporting from EDT workspace with on-disk project refresh (--project)..."
		$exportArgs += @("--project", $EdtProjectPath)
	} else {
		Write-Host "Exporting EDT project to Designer XML (first run may take 10-30 minutes)..."
		$exportArgs += @("--project", $EdtProjectPath)
	}

	Invoke-EdtCli $EdtCli $exportArgs $LogFilePath
}

$v8Preferred = if (-not [string]::IsNullOrWhiteSpace($env:ONEC_V8_VERSION)) {
	$env:ONEC_V8_VERSION
} else {
	Get-ProjectRuntimeVersion -ProjectRoot $ProjectRoot
}
$v8 = Find-OneCPlatformExe -PreferredVersion $v8Preferred
$edtCli = Find-EdtCli

if ([string]::IsNullOrWhiteSpace($OutputEpf)) {
	$OutputEpf = Join-Path $ProjectRoot "bin\GetManHTTP.epf"
} elseif (-not [System.IO.Path]::IsPathRooted($OutputEpf)) {
	$OutputEpf = Join-Path $ProjectRoot $OutputEpf
}
$outputPath = [System.IO.Path]::GetFullPath($OutputEpf)
$outputDir = Split-Path -Parent $outputPath
if (-not (Test-Path -LiteralPath $outputDir)) {
	New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$tempBase = if (-not [string]::IsNullOrWhiteSpace($env:RUNNER_TEMP)) { $env:RUNNER_TEMP } else { [System.IO.Path]::GetTempPath() }
$workRoot = Join-Path $tempBase ("getmanhttp-build-" + [guid]::NewGuid().ToString("N"))
$exportPath = Join-Path $workRoot "designer-xml"
$designerLog = Join-Path $workRoot "designer.log"
$edtCliLog = Join-Path $workRoot "edtcli.log"
$edtTimeoutSec = 3600

$edtProjectName = Get-EdtProjectName -ProjectRoot $ProjectRoot
$workspaceInfo = Resolve-EdtWorkspace -ProjectRoot $ProjectRoot
$useExistingWorkspace = $workspaceInfo.UseExisting
$wsPath = if ($useExistingWorkspace) { $workspaceInfo.Path } else { Join-Path $workRoot "edt-ws" }

New-Item -ItemType Directory -Force -Path $exportPath | Out-Null
if (-not $useExistingWorkspace) {
	New-Item -ItemType Directory -Force -Path $wsPath | Out-Null
}

if (Get-Process -Name "1cedt" -ErrorAction SilentlyContinue) {
	Write-Warning "1C:EDT is running. Close the IDE before CLI build to avoid workspace locks."
}

try {
	$edtProjectPath = $ProjectRoot
	if (-not $useExistingWorkspace) {
		$projectAlias = New-EdtProjectPathAlias -ProjectRoot $ProjectRoot -ParentDirectory $workRoot -EdtProjectName $edtProjectName
		$edtProjectPath = $projectAlias.Path
	}

	Write-Host "Project: $ProjectRoot"
	Write-Host "EDT workspace (-data): $wsPath"
	Write-Host "EDT project name: $edtProjectName"
	Write-Host "EDT CLI: $edtCli"
	Write-Host "Platform ($v8Preferred): $v8"
	Write-Host "Export to: $exportPath"

	Export-EdtProjectToDesignerXml -EdtCli $edtCli `
		-WorkspacePath $wsPath `
		-EdtProjectPath $edtProjectPath `
		-EdtProjectName $edtProjectName `
		-ExportPath $exportPath `
		-LogFilePath $edtCliLog `
		-TimeoutSec $edtTimeoutSec `
		-UseExistingWorkspace $useExistingWorkspace

	$processorXml = Join-Path $exportPath "ExternalDataProcessors\$ProcessorName.xml"
	if (-not (Test-Path -LiteralPath $processorXml)) {
		$found = Get-ChildItem -Path (Join-Path $exportPath "ExternalDataProcessors") -Filter "*.xml" -ErrorAction SilentlyContinue
		if ($found.Count -eq 1) {
			$processorXml = $found[0].FullName
		} else {
			throw "Processor XML not found: $processorXml"
		}
	}

	# Ensure collection form pages use left tabs. EDT may export as None/TabsOnTop;
	# Designer 8.3.27 expects TabsOnLeftHorizontal (not TabsOnLeft).
	$formsRoot = Join-Path $exportPath "ExternalDataProcessors\$ProcessorName\Forms"
	if (Test-Path -LiteralPath $formsRoot) {
		foreach ($candidate in (Get-ChildItem -Path $formsRoot -Recurse -Filter "Form.xml" -ErrorAction SilentlyContinue)) {
			$bytes = [System.IO.File]::ReadAllBytes($candidate.FullName)
			$hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
			$text = if ($hasBom) {
				[System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3)
			} else {
				[System.Text.Encoding]::UTF8.GetString($bytes)
			}
			if ($text -notmatch 'id="100"' -or $text -notmatch 'id="103"' -or $text -notmatch 'BasicAuth') {
				continue
			}
			$current = [regex]::Match($text, '<PagesRepresentation>([^<]+)</PagesRepresentation>').Groups[1].Value
			if ($current -ne '' -and $current -ne 'TabsOnLeftHorizontal') {
				$text = [regex]::Replace(
					$text,
					'<PagesRepresentation>[^<]+</PagesRepresentation>',
					'<PagesRepresentation>TabsOnLeftHorizontal</PagesRepresentation>')
				$utf8Bom = New-Object System.Text.UTF8Encoding $true
				$text = $text -replace "`r`n", "`n" -replace "`n", "`r`n"
				[System.IO.File]::WriteAllText($candidate.FullName, $text, $utf8Bom)
				Write-Host "Patched collection form pagesRepresentation $current -> TabsOnLeftHorizontal"
			}
			break
		}
	}

	Write-Host "Building EPF: $outputPath"
	Invoke-Platform $v8 @(
		"DESIGNER",
		"/DisableStartupDialogs",
		"/LoadExternalDataProcessorOrReportFromFiles",
		$processorXml,
		$outputPath,
		"/Out",
		$designerLog
	)

	if (-not (Test-Path -LiteralPath $outputPath)) {
		if (Test-Path -LiteralPath $designerLog) {
			Get-Content -LiteralPath $designerLog -Tail 80 | Write-Host
		}
		throw "Output file was not created: $outputPath"
	}

	Write-Host "Done: $outputPath"
}
catch {
	if (Test-Path -LiteralPath $edtCliLog) {
		Write-Host "--- edtcli.log (last lines) ---"
		Get-Content -LiteralPath $edtCliLog -Tail 50 | Write-Host
	}
	throw
}
finally {
	if (Test-Path -LiteralPath $workRoot) {
		Remove-Item -LiteralPath $workRoot -Recurse -Force -ErrorAction SilentlyContinue
	}
}
