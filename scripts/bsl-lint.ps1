# Local BSL static analysis (same as .github/workflows/bsl-lint.yml).
# Requires JDK 21+ (Temurin): https://adoptium.net/
#
# From repo root:
#   .\scripts\bsl-lint.ps1
#
# Exit code: 0 if analyze succeeded; otherwise Java/download/analyze error.

#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$BslLanguageServerVersion = "1.0.6"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$CiDir = Join-Path $RepoRoot ".ci"
$ReportsDir = Join-Path $RepoRoot "reports"
$JarName = "bsl-language-server-$BslLanguageServerVersion-exec.jar"
$JarPath = Join-Path $CiDir $JarName
$DownloadUrl = "https://github.com/1c-syntax/bsl-language-server/releases/download/v$BslLanguageServerVersion/$JarName"

function Test-JavaVersionAtLeast21 {
	
	$javaCmd = Get-Command java -ErrorAction SilentlyContinue
	If ($null -eq $javaCmd) {
		Write-Error "Java not found in PATH. Install JDK 21 (Temurin) and add java to PATH."
	}
	
	$oldErrorAction = $ErrorActionPreference
	$ErrorActionPreference = "Continue"
	Try {
		$versionOutput = & java -version 2>&1 | Out-String
	} Finally {
		$ErrorActionPreference = $oldErrorAction
	}
	If ($versionOutput -match 'version "(\d+)') {
		$major = [int]$Matches[1]
		If ($major -lt 21) {
			Write-Error "Java 21+ required, found major version $major. Run: java -version"
		}
		Return
	}
	
	Write-Warning "Could not detect Java version; continuing with analyze."
	
}

Set-Location $RepoRoot

Write-Host "Repository: $RepoRoot"
Write-Host "BSL Language Server: v$BslLanguageServerVersion"

Test-JavaVersionAtLeast21

New-Item -ItemType Directory -Force -Path $CiDir, $ReportsDir | Out-Null

If (-not (Test-Path $JarPath)) {
	Write-Host "Downloading $JarName ..."
	Invoke-WebRequest -Uri $DownloadUrl -OutFile $JarPath -UseBasicParsing
}

Write-Host "Running analyze ..."
$oldErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Continue"
Try {
	& java -Xmx2g -jar $JarPath analyze `
		--srcDir (Join-Path $RepoRoot "src") `
		--workspaceDir $RepoRoot `
		--configuration (Join-Path $RepoRoot ".bsl-language-server.json") `
		--outputDir $ReportsDir `
		--reporter junit `
		--reporter console
	$exitCode = $LASTEXITCODE
} Finally {
	$ErrorActionPreference = $oldErrorAction
}
If ($exitCode -ne 0) {
	Write-Host "Analyze failed with exit code $exitCode. Reports: $ReportsDir" -ForegroundColor Red
	Exit $exitCode
}

Write-Host "Done. Reports: $ReportsDir" -ForegroundColor Green
Exit 0
