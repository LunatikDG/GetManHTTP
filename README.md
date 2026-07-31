# HTTP-client for 1C:Enterprise

[![License](https://img.shields.io/badge/license-GPL--3.0-blue)](https://github.com/LunatikDG/GetManHTTP/blob/main/LICENSE.txt)
[![1C Version](https://img.shields.io/badge/1С-8.3.26%2B-orange)](#)
[![Release](https://img.shields.io/badge/release-1.3.21-red)](https://github.com/LunatikDG/GetManHTTP/releases)
[![BSL Lint](https://github.com/LunatikDG/GetManHTTP/actions/workflows/bsl-lint.yml/badge.svg)](https://github.com/LunatikDG/GetManHTTP/actions/workflows/bsl-lint.yml)

<p align="center">
  <a href="#english">🇬🇧 English</a> •
  <a href="#русский">🇷🇺 Русский</a>
</p>

---

<a name="english"></a>
## 🇬🇧 English

### Description

An HTTP client external data processor for **1C:Enterprise**. Built for
integrating 1C with external services, REST APIs, and web applications —
something the platform doesn't handle well out of the box.

### Features

- Sends **GET**, **POST**, **PUT**, **DELETE**, **PATCH** requests
- Multiple saved requests in a hierarchical sidebar tree with folders (add / rename / delete / switch)
- Custom headers and query parameters
- JSON, XML, form-data and binary request body support
- Option to send a request without a body
- Response and status code handling
- Save response body to a file (auto-selects JSON/XML/HTML by Content-Type)
- Settings form with configurable HTTP timeout and autosave interval
- Authorization support (Basic, Bearer Token)
- HTTPS support
- Persists all request list items and their data between 1C sessions
- Optional auto-save while the form is open (off by default; interval configurable in settings)
- Safe settings persistence on form close (skips save on platform shutdown)
- Request execution time measurement
- Detailed response inspection (response headers, status code, request body)
- Automatic JSON/XML response formatting
- **Client / Server** execution context per request (toolbar switch); default context in settings
- Result panel shows where the request ran (**Executed: client** / **server**)

### HTTP execution context

Each saved request stores its own mode:

| Mode | Behavior |
|------|----------|
| **Client** | HTTP goes from the user’s machine (1C thick client session). |
| **Server** | HTTP runs on the 1C application server (cluster worker). |

In **server** mode the request uses the **server’s network** and OS account, not the user’s PC. It may reach internal URLs that are blocked from the client (see [SECURITY.md](.github/SECURITY.md)).

**File infobase:** client and server often share one process; both modes may behave similarly — this is expected, not a defect.

**BINARY body in server mode:** the file is uploaded to temporary storage on the server (`НачатьПомещениеФайлаНаСервер`) before the request is sent.

Older saved requests without a stored mode default to **Client** (unchanged behavior).

### Installation

1. Download the [latest release](https://github.com/LunatikDG/GetManHTTP/releases)
2. Load the external data processor into your 1C configuration via
   *File → Open*

### Releasing (maintainers)

1. Push sources to `main` (folder `bin/` is gitignored; `.epf` is not stored in the repo).
2. Create and push a tag: `git tag -a v_X_Y_Z -m "GetManHTTP vX.Y.Z"` then `git push origin v_X_Y_Z`
3. Workflow **Release** builds `bin/GetManHTTP.epf` on GitHub and attaches it to the release (version is in the git tag only).
4. Before tagging, bump `ВерсияОбработки()` in `Forms/Форма/Module.bsl` (form title) and the version line in form help / README badge to match the tag (`v_1_3_21` → `1.3.21`).

**GitHub repository secrets** (Settings → Secrets and variables → Actions):

| Secret | Purpose |
|--------|---------|
| `ONEC_USERNAME` | Login for [releases.1c.ru](https://releases.1c.ru) (platform + EDT download in CI) |
| `ONEC_PASSWORD` | Password for releases.1c.ru |
| `ONEC_LICENCE` | Optional: contents of `licence.lic` for the Windows CI runner |

Local build (1C:EDT + platform installed):

```powershell
cd GetManHTTP_v_1_1_1
.\scripts\build-epf.ps1
# or: .\scripts\build-epf.ps1 -OutputEpf "bin\GetManHTTP.epf"
```

Or `scripts\build-epf.cmd`. Match **1C:EDT** and platform to `.github/workflows/release.yml` (`EDT_VERSION` **2025.1.5**, `V8_VERSION` **8.3.27**). If only EDT 2024.x is installed, the script warns and may fail on export — install EDT 2025.1 or set `ONEC_EDT_CLI` to its `1cedtcli.exe`.

Close **1C:EDT** before building. The script auto-detects the workspace in the parent folder (`GetManHTTP` with `.metadata`) and exports via `--project-name` (recommended on your machine). First CLI export in a fresh workspace can take **10–30+ minutes**.

Optional: `ONEC_EDT_DATA`, `ONEC_EDT_VERSION`, `ONEC_EDT_CLI`, `ONEC_V8_EXE`, `ONEC_V8_VERSION`. For the `.epf` step the script defaults to **8.3.27** from `DT-INF/PROJECT.PMF`, not the newest installed platform (e.g. 8.5.x).
Pushes and pull requests to `main` that touch `src/` run **BSL Language Server** static analysis (see `.github/workflows/bsl-lint.yml` and `.bsl-language-server.json`).

Before push (JDK **21** required locally):

```powershell
.\scripts\bsl-lint.ps1
```

Or: `scripts\bsl-lint.cmd`, or `./scripts/bsl-lint.sh` (Git Bash/WSL). JAR and reports go to `.ci/` and `reports/` (gitignored).

### Requirements

- 1C:Enterprise 8.3.26 (not tested on earlier versions) or higher
- Internet access
- Permission to use external data processors

### Contact

Feedback, suggestions and bug reports are welcome:

- Email: <main@lunatikdg.ru>
- Telegram: [@LunatikDG](https://t.me/LunatikDG)

---

<a name="русский"></a>
## 🇷🇺 Русский

### Описание

Данная обработка предназначена для отправки HTTP-запросов из
1С:Предприятие. Подходит для интеграций с внешними сервисами, API и
веб-приложениями.

### Возможности

- Отправка **GET**, **POST**, **PUT**, **DELETE**, **PATCH** запросов
- Несколько сохранённых запросов в иерархическом дереве слева с папками (добавление / переименование / удаление / переключение)
- Передача заголовков и параметров
- Поддержка JSON-, XML-, form-data- и двоичных тел запросов
- Вариант отправки без тела запроса
- Отправка двоичных файлов
- Обработка ответа и кода состояния
- Сохранение тела ответа в файл (автовыбор JSON/XML/HTML по Content-Type)
- Форма настроек с настраиваемым таймаутом HTTP и интервалом автосохранения
- Работа с авторизацией (Basic, Bearer Token)
- Поддержка HTTPS
- Сохраняет все элементы списка запросов и их данные между сеансами 1С
- Опциональное автосохранение при открытой форме (по умолчанию выключено; интервал задаётся в настройках)
- Безопасное сохранение настроек при закрытии (без ошибки при завершении работы платформы)
- Поддержка замера времени выполнения запроса
- Отображение детальной информации результата запроса (заголовки ответа,
  код ответа, тело запроса)
- Автоматическое форматирование JSON/XML в ответе
- Контекст выполнения **Клиент / Сервер** для каждого запроса (переключатель у метода); значение по умолчанию — в настройках
- В панели результата отображается, где выполнен запрос (**Выполнен: клиент** / **сервер**)

### Контекст выполнения HTTP

Режим хранится отдельно для каждого запроса в списке:

| Режим | Поведение |
|-------|-----------|
| **Клиент** | Запрос уходит с рабочей станции пользователя (сеанс толстого клиента). |
| **Сервер** | Запрос выполняется на сервере 1С (рабочий процесс кластера). |

В режиме **Сервер** используется **сеть и учётная запись сервера**, а не ПК пользователя. Возможен доступ к внутренним URL, недоступным с клиента (см. [SECURITY.md](.github/SECURITY.md)).

**Файловая база:** клиент и сервер часто работают в одном процессе — оба режима могут вести себя одинаково; это нормально, а не ошибка.

**Двоичное тело (BINARY) в режиме «Сервер»:** файл сначала передаётся на сервер во временное хранилище (`НачатьПомещениеФайлаНаСервер`), затем отправляется в запросе.

У старых сохранённых запросов без поля режима подставляется **Клиент** (поведение как раньше).

### Установка

1. Скачайте [последний релиз](https://github.com/LunatikDG/GetManHTTP/releases)
2. Загрузите обработку в конфигурацию 1С через *Файл → Открыть*

### Релиз (для мейнтейнеров)

1. Исходники в `main` (каталог `bin/` в git не хранится; `.epf` только в релизах).
2. Создайте и запушьте тег: `git tag -a v_X_Y_Z -m "GetManHTTP vX.Y.Z"` затем `git push origin v_X_Y_Z`
3. Workflow **Release** собирает `bin/GetManHTTP.epf` на GitHub и прикладывает к релизу (номер версии — только в теге).
4. Перед тегом обновите `ВерсияОбработки()` в `Forms/Форма/Module.bsl` (заголовок формы) и строку версии в справке формы / бейдже README под тег (`v_1_3_21` → `1.3.21`).

**Секреты репозитория** (Settings → Secrets and variables → Actions):

| Секрет | Назначение |
|--------|------------|
| `ONEC_USERNAME` | Логин [releases.1c.ru](https://releases.1c.ru) (скачивание платформы и EDT в CI) |
| `ONEC_PASSWORD` | Пароль releases.1c.ru |
| `ONEC_LICENCE` | Необязательно: содержимое файла `licence.lic` для Windows-раннера |

Локальная сборка (нужны 1C:EDT и платформа):

```powershell
cd GetManHTTP_v_1_1_1
.\scripts\build-epf.ps1
# or: .\scripts\build-epf.ps1 -OutputEpf "bin\GetManHTTP.epf"
```

Или `scripts\build-epf.cmd`. Версии **1C:EDT** и платформы — как в `.github/workflows/release.yml` (`EDT_VERSION` **2025.1.5**, `V8_VERSION` **8.3.27**). Если установлен только EDT 2024.x, будет предупреждение и export может падать — поставьте EDT 2025.1 или укажите `ONEC_EDT_CLI`.

Перед сборкой **закройте 1C:EDT**. Скрипт сам находит рабочую область в родительской папке (`GetManHTTP` с `.metadata`) и делает export через `--project-name`. В чистом workspace первый export может занять **10–30+ минут**.

Опционально: `ONEC_EDT_DATA`, `ONEC_EDT_VERSION`, `ONEC_EDT_CLI`, `ONEC_V8_EXE`, `ONEC_V8_VERSION`. Для сборки `.epf` скрипт по умолчанию берёт платформу **8.3.27** из `DT-INF/PROJECT.PMF`, а не самую новую установленную (8.5.x).
При push и pull request в `main`, если меняется `src/`, запускается статический анализ **BSL Language Server** (см. `.github/workflows/bsl-lint.yml` и `.bsl-language-server.json`).

Перед push (локально нужна **Java 21**):

```powershell
.\scripts\bsl-lint.ps1
```

Также: `scripts\bsl-lint.cmd` или `./scripts/bsl-lint.sh` (Git Bash/WSL). JAR и отчёты попадают в `.ci/` и `reports/` (в git не коммитятся).

### Требования

- 1С:Предприятие 8.3.26 (на более ранних версиях не тестировалось) и выше
- Доступ в интернет
- Разрешение на использование внешних обработок

### Связь

Замечания, пожелания и обратную связь можно отправить по следующим
контактам:

- Почта: <main@lunatikdg.ru>
- Telegram: [@LunatikDG](https://t.me/LunatikDG)
