#!/usr/bin/env bash
# Локальный статический анализ BSL (то же, что job BSL Lint на GitHub Actions).
# Требуется JDK 21+.
#
# Запуск из корня репозитория:
#   ./scripts/bsl-lint.sh

set -euo pipefail

BSL_LANGUAGE_SERVER_VERSION="1.0.6"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CI_DIR="${REPO_ROOT}/.ci"
REPORTS_DIR="${REPO_ROOT}/reports"
JAR="${CI_DIR}/bsl-language-server-${BSL_LANGUAGE_SERVER_VERSION}-exec.jar"
URL="https://github.com/1c-syntax/bsl-language-server/releases/download/v${BSL_LANGUAGE_SERVER_VERSION}/bsl-language-server-${BSL_LANGUAGE_SERVER_VERSION}-exec.jar"

java_major() {
	java -version 2>&1 | head -n 1 | sed -n 's/.*version "\([0-9]*\).*/\1/p'
}

if ! command -v java >/dev/null 2>&1; then
	echo "Java не найдена в PATH. Установите JDK 21." >&2
	exit 1
fi

MAJOR="$(java_major)"
if [[ -z "${MAJOR}" || "${MAJOR}" -lt 21 ]]; then
	echo "Нужна Java 21+, сейчас: ${MAJOR:-?}. Проверьте: java -version" >&2
	exit 1
fi

cd "${REPO_ROOT}"
mkdir -p "${CI_DIR}" "${REPORTS_DIR}"

if [[ ! -f "${JAR}" ]]; then
	echo "Скачивание bsl-language-server-${BSL_LANGUAGE_SERVER_VERSION}-exec.jar ..."
	curl -fsSL -o "${JAR}" "${URL}"
fi

echo "Запуск analyze ..."
java -Xmx2g -jar "${JAR}" analyze \
	--srcDir src \
	--workspaceDir . \
	--configuration .bsl-language-server.json \
	--outputDir reports \
	--reporter junit \
	--reporter console

echo "Готово. Отчёты: ${REPORTS_DIR}"
