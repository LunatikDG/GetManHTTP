# Changelog

<p align="center">
  <a href="#english">English</a> •
  <a href="#русский">Русский</a>
</p>

All notable changes to **GetManHTTP** are documented in this file / Все заметные
изменения **GetManHTTP** фиксируются в этом файле.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions correspond to git tags (`v_X_Y_Z` tag → `X.Y.Z` version); see
[Releasing](README.md#releasing-maintainers) in the README for how releases are cut.

Формат близок к [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/).
Версии соответствуют git-тегам (`v_X_Y_Z` → `X.Y.Z`); см.
[Релиз (для мейнтейнеров)](README.md#релиз-для-мейнтейнеров) в README.

---

<a name="english"></a>

## English

## [Unreleased]

### Changed

- JWT Bearer signing migrated from hand-rolled HMAC (`ХешированиеДанных`) to
  platform `ТокенДоступа` / `АлгоритмПодписиТокенаДоступа` for **HS256**,
  **HS384**, and **HS512** (Refs #13). Schema fields unchanged
  (`algorithm` / `secret` / `claims` / `ttlSeconds`).

## [1.3.25] - 2026-08-07

<a name="changelog-1-3-25-en"></a>

### Added

- Automatic request headers (issue #22): `Content-Type` by body mode
  (JSON/XML/`multipart/form-data`/binary MIME from file extension), plus
  `Accept: */*` and `User-Agent: GetManHTTP/{version}` in the headers table with
  an **Авто** flag. Manual rows are not overwritten; editing an auto row clears
  the flag. Auto rows are sorted above manual ones, shown in gray, and hidden by
  default behind an eye button on the headers table command bar (hidden auto
  headers are still sent). Native collection JSON stores `"auto": true` on headers; Postman
  import/export treats headers as manual. `Content-Length` is not set in the
  table (platform sets it on send). FORM_DATA still gets `boundary` on the wire.
- Authorization type **Bearer Token** (`BearerToken`): single token field, fixed
  `Authorization: Bearer …` prefix (issue #12). Generic **Token** kept for a custom
  prefix (UI label: «Токен (свой префикс)»). Postman `bearer` import/export maps to
  `BearerToken`.
- Authorization type **JWT Bearer** (`JwtBearer`, issue #13): HS256/HS512 via
  platform `ХешированиеДанных` + HMAC (RFC 2104), fields `algorithm` / `secret` /
  `claims` (JSON) / `ttlSeconds` (`iat`/`exp` when TTL > 0). Auth schema and crypto
  live in the data processor object module (shared by main and collection forms).
  Postman `jwt` import/export maps for HS*.

## [1.3.24] - 2026-08-04

<a name="changelog-1-3-24-en"></a>

### Added

- Authorization type **API Key** (`key` / `value` / add to Header or Query) on the
  main request form and collection settings, including Postman `apikey` import/export.
- Bilingual specification of the native collection JSON format
  ([docs/collection-format.md](docs/collection-format.md)) — `GetManHTTP.Collection`
  schema v1.
- **form-data file parts** (issue #9): each field can be Text or File (multiple
  files + text in one multipart body), binary body assembly with a **50 MB**
  in-memory limit, optional Content-Type override, client/server send modes, and
  native/Postman import-export of `type=file` parts.

### Fixed

- Auth form fields (`ЗначениеАвторизации1..6`) are reset to the new schema defaults
  when the authorization type changes (no stale values carried over by matching keys).

## [1.3.23] - 2026-08-02

<a name="changelog-1-3-23-en"></a>

### Added

- Collection import/export from the **collection settings** form (GetManHTTP native JSON
  schema v1 and Postman Collection v2.1). Collection and item UUIDs are
  preserved for round-trip; unsupported Postman features (scripts, JWT,
  API key auth, saved responses, …) are ignored.
- Bilingual [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) (Contributor Covenant 2.1).

### Fixed

- Dragging a request/folder onto a request crashed with
  `Метод объекта не обнаружен (ПолучитьРодитель)` during post-drag
  normalization. Form tree rows use `ПолучитьРодителя()`; invalid nesting
  (anything under a request) is still flattened so a request’s parent can
  only be a folder.

### Changed

- Release workflow builds `.epf` on a **self-hosted** Windows runner
  (`onec-build`) with local 1C:EDT/platform/license server instead of
  GitHub-hosted `windows-latest` (device-bound 1C licenses cannot activate there).
- Maintainer docs: EDT Lite stays in the user profile (`AppData` + `.p2`); the
  runner service needs ACL (or to run as that user). A bare copy under
  `ProgramData` is not sufficient for EDT Lite. Host tool paths
  (`ONEC_EDT_CLI`, …) are set on the runner via `C:\actions-runner\.env`, not in
  the committed workflow YAML.
- EDT project renamed from `GetManHTTP_v_1_1_1` to `GetManHTTP`.

## [1.3.22] - 2026-07-31

### Fixed

- JSON response beautify failed when object keys contained characters invalid for 1C
  Structure property names (e.g. `user-agent` in postman-echo). Objects are now read into
  Map (`ПрочитатьJSON(..., True)`).
- CI: install Liberica JDK 17 with JavaFX so the Release workflow can run 1C:EDT headless.

### Changed

- README refreshed with bilingual docs, screenshots under `docs/images/`, plus
  `CONTRIBUTING.md` and a pull-request template.

## [1.3.21] - 2026-07-31

### Added

- Hierarchical authorization: a request can inherit its auth type/parameters from its owning
  collection instead of duplicating them.

### Fixed

- Auth parameters/fields are cleared when the authorization type is switched, instead of
  leaving stale values from the previous type behind.
- BSL Language Server lint findings in the collection auth form and the main form module.
- CI: pin 1C:EDT to version 2025.1.5 (the version available in the 1C update catalog) so the
  Release workflow build stops failing.
- CI: Release workflow YAML and the `secrets` conditional for the v1.3.19 release.

## [1.3.19] - 2026-07-30

### Added

- Per-request **Client / Server** HTTP execution context, switchable from the toolbar, with a
  default execution context configurable in settings.
- CI: automated `.epf` build in the Release workflow, attached to GitHub Releases on tag push.

### Changed

- `bin/` build artifacts are no longer tracked in git; only the CI-built `.epf` ships with a
  release.

## [1.3.17] - 2026-07-29

### Added

- Synchronization between the request URI and the query-parameter table (editing one updates
  the other).
- Per-header "active" toggle, so a header can be disabled without deleting it.
- CI: BSL Language Server static-analysis workflow (`bsl-lint`), running on pushes/PRs that
  touch `src/`.

## [1.3.13] - 2026-07-28

### Added

- Request collections: group saved requests into named collections with their own settings
  (including authorization).
- Settings, revision 4.

### Fixed

- Bugs in deleting requests/collections from the sidebar tree.

## [1.3.4] - 2026-07-27

### Added

- Hierarchical request tree with folders (previously a flat list).
- Settings, revision 3.
- In-app help panels on the request and settings forms.
- `SECURITY.md` policy.

## [1.2.18] - 2026-07-26

### Added

- Configurable auto-save interval (auto-save itself stays off by default).
- Confirmation prompt before closing the form with unsaved changes.

### Fixed

- Settings persistence no longer errors out during platform shutdown.

## [1.2.12] - 2026-07-24

### Added

- Multiple saved requests in a sidebar list, with full state persisted between 1C sessions
  (previously a single in-memory request).

## [1.2.4] - 2026-07-23

### Added

- `form-data` request body support.
- Option to send a request with no body at all.

### Fixed

- Form layout issues.

## [1.2.2] - 2026-07-22

### Added

- Dedicated settings form.
- Configurable HTTP timeout.

### Changed

- Saving a response body to a file now auto-selects the JSON/XML/HTML extension based on the
  response `Content-Type` instead of always using a generic extension.

## [1.1.58] - 2026-07-21

### Added

- XML request/response body support (previously JSON-only).
- Auto-save while the form is open.
- Export of the response body to a file.

### Fixed

- Various stability fixes.

---

<a name="русский"></a>

## Русский

## [Unreleased]

### Изменено

- Подпись JWT Bearer переведена с самописного HMAC (`ХешированиеДанных`) на
  платформенный `ТокенДоступа` / `АлгоритмПодписиТокенаДоступа` для **HS256**,
  **HS384** и **HS512** (Refs #13). Поля схемы без изменений
  (`algorithm` / `secret` / `claims` / `ttlSeconds`).

## [1.3.25] - 2026-08-07

<a name="changelog-1-3-25-ru"></a>

### Добавлено

- Автоматические заголовки запроса (issue #22): `Content-Type` по типу тела
  (JSON/XML/`multipart/form-data`/MIME binary по расширению файла), плюс
  `Accept: */*` и `User-Agent: GetManHTTP/{version}` в таблице заголовков с
  флагом **Авто**. Ручные строки не перезаписываются; правка авто-строки снимает
  флаг. Авто-строки выше ручных, серым текстом и по умолчанию скрыты за кнопкой
  с иконкой глаза на командной панели таблицы (скрытые автозаголовки всё равно
  отправляются). В native JSON коллекций у заголовков поле `"auto": true`;
  Postman импорт/экспорт считает заголовки ручными. `Content-Length` в таблицу
  не задаётся (его выставляет платформа при отправке). Для FORM_DATA на wire
  по-прежнему добавляется `boundary`.
- Тип авторизации **Bearer Token** (`BearerToken`): одно поле токена, фиксированный
  префикс `Authorization: Bearer …` (issue #12). Generic **Token** сохранён для
  своего префикса (в UI: «Токен (свой префикс)»). Импорт/экспорт Postman `bearer`
  соответствует `BearerToken`.
- Тип авторизации **JWT Bearer** (`JwtBearer`, issue #13): HS256/HS512 через
  `ХешированиеДанных` платформы + HMAC (RFC 2104), поля `algorithm` / `secret` /
  `claims` (JSON) / `ttlSeconds` (`iat`/`exp` при TTL > 0). Схема авторизации и
  крипто вынесены в модуль объекта обработки (общие для основной формы и
  коллекции). Импорт/экспорт Postman `jwt` для HS*.

## [1.3.24] - 2026-08-04

<a name="changelog-1-3-24-ru"></a>

### Добавлено

- Тип авторизации **API Key** (`key` / `value` / добавить в Header или Query) на
  основной форме запроса и в настройках коллекции, включая импорт/экспорт Postman
  `apikey`.
- Двуязычная спецификация нативного JSON-формата коллекций
  ([docs/collection-format.md](docs/collection-format.md)) — схема
  `GetManHTTP.Collection` v1.
- **Файлы в form-data** (issue #9): у каждого поля тип Текст или Файл (несколько
  файлов и текст в одном multipart), двоичная сборка тела с лимитом **50 МБ**,
  ручной Content-Type, режимы клиент/сервер, импорт/экспорт `type=file` в
  native и Postman.

### Исправлено

- Поля авторизации на форме (`ЗначениеАвторизации1..6`) сбрасываются к значениям
  по умолчанию новой схемы при смене типа (без переноса устаревших значений по
  совпадающим ключам).

## [1.3.23] - 2026-08-02

<a name="changelog-1-3-23-ru"></a>

### Добавлено

- Импорт/экспорт коллекций из формы **настроек коллекции** (нативный JSON GetManHTTP,
  схема v1, и Postman Collection v2.1). UUID коллекций и элементов сохраняются
  для round-trip; неподдерживаемые возможности Postman (скрипты, JWT, API key auth,
  сохранённые ответы и т.п.) игнорируются.
- Двуязычный [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) (Contributor Covenant 2.1).

### Исправлено

- При перетаскивании запроса/папки на запрос возникала ошибка
  `Метод объекта не обнаружен (ПолучитьРодитель)` при нормализации после DnD.
  В дереве формы используется `ПолучитьРодителя()`; недопустимая вложенность
  (всё, что оказалось под запросом) по-прежнему выравнивается, так что родителем
  запроса может быть только папка.

### Изменено

- Workflow Release собирает `.epf` на **self-hosted** Windows-runner
  (`onec-build`) с локальными 1C:EDT/платформой/сервером лицензий вместо
  GitHub-hosted `windows-latest` (привязанные к устройству лицензии 1С там не
  активируются).
- Документация для мейнтейнеров: EDT Lite остаётся в профиле пользователя
  (`AppData` + `.p2`); службе runner нужны ACL (или запуск от того же пользователя).
  Простого копирования в `ProgramData` для EDT Lite недостаточно. Пути к инструментам
  (`ONEC_EDT_CLI` и др.) задаются на runner через `C:\actions-runner\.env`, а не в
  закоммиченном YAML workflow.
- Проект EDT переименован с `GetManHTTP_v_1_1_1` в `GetManHTTP`.

## [1.3.22] - 2026-07-31

### Исправлено

- Красивое форматирование JSON-ответа падало, если ключи объектов содержали символы,
  недопустимые в именах свойств Структуры 1С (например `user-agent` в postman-echo).
  Объекты теперь читаются в Соответствие (`ПрочитатьJSON(..., True)`).
- CI: установка Liberica JDK 17 с JavaFX, чтобы Release workflow мог запускать 1C:EDT
  в headless-режиме.

### Изменено

- README обновлён: двуязычная документация, скриншоты в `docs/images/`, плюс
  `CONTRIBUTING.md` и шаблон pull request.

## [1.3.21] - 2026-07-31

### Добавлено

- Иерархическая авторизация: запрос может наследовать тип и параметры авторизации
  от своей коллекции вместо дублирования.

### Исправлено

- Параметры/поля авторизации очищаются при смене типа авторизации, а не оставляют
  устаревшие значения предыдущего типа.
- Замечания BSL Language Server в форме авторизации коллекции и в модуле основной формы.
- CI: фиксация 1C:EDT на версии 2025.1.5 (доступна в каталоге обновлений 1С), чтобы
  сборка Release workflow не падала.
- CI: YAML Release workflow и условие `secrets` для релиза v1.3.19.

## [1.3.19] - 2026-07-30

### Добавлено

- Контекст выполнения HTTP **Клиент / Сервер** для каждого запроса, переключаемый
  с панели инструментов; контекст по умолчанию настраивается в настройках.
- CI: автоматическая сборка `.epf` в Release workflow и прикрепление к GitHub Releases
  при пуше тега.

### Изменено

- Артефакты сборки в `bin/` больше не хранятся в git; в релизе поставляется только
  `.epf`, собранный CI.

## [1.3.17] - 2026-07-29

### Добавлено

- Синхронизация URI запроса и таблицы параметров query (правка одного обновляет другое).
- Переключатель «активен» для заголовков — заголовок можно отключить, не удаляя его.
- CI: workflow статического анализа BSL Language Server (`bsl-lint`) на push/PR,
  затрагивающих `src/`.

## [1.3.13] - 2026-07-28

### Добавлено

- Коллекции запросов: группировка сохранённых запросов в именованные коллекции с
  собственными настройками (включая авторизацию).
- Настройки, ревизия 4.

### Исправлено

- Ошибки при удалении запросов/коллекций из дерева боковой панели.

## [1.3.4] - 2026-07-27

### Добавлено

- Иерархическое дерево запросов с папками (раньше был плоский список).
- Настройки, ревизия 3.
- Встроенные панели справки на формах запроса и настроек.
- Политика `SECURITY.md`.

## [1.2.18] - 2026-07-26

### Добавлено

- Настраиваемый интервал автосохранения (само автосохранение по умолчанию выключено).
- Подтверждение перед закрытием формы с несохранёнными изменениями.

### Исправлено

- Сохранение настроек больше не падает при завершении работы платформы.

## [1.2.12] - 2026-07-24

### Добавлено

- Несколько сохранённых запросов в списке боковой панели с полным сохранением
  состояния между сеансами 1С (раньше — один запрос в памяти).

## [1.2.4] - 2026-07-23

### Добавлено

- Поддержка тела запроса `form-data`.
- Возможность отправить запрос без тела.

### Исправлено

- Проблемы вёрстки формы.

## [1.2.2] - 2026-07-22

### Добавлено

- Отдельная форма настроек.
- Настраиваемый HTTP-таймаут.

### Изменено

- При сохранении тела ответа в файл расширение JSON/XML/HTML выбирается по
  `Content-Type` ответа, а не всегда общее.

## [1.1.58] - 2026-07-21

### Добавлено

- Поддержка XML в теле запроса/ответа (раньше только JSON).
- Автосохранение, пока форма открыта.
- Экспорт тела ответа в файл.

### Исправлено

- Разные исправления стабильности.

[Unreleased]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_25...HEAD
[1.3.25]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_24...v_1_3_25
[1.3.24]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_23...v_1_3_24
[1.3.23]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_22...v_1_3_23
[1.3.22]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_21...v_1_3_22
[1.3.21]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_19...v_1_3_21
[1.3.19]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_17...v_1_3_19
[1.3.17]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_13...v_1_3_17
[1.3.13]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_4...v_1_3_13
[1.3.4]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_2_18...v_1_3_4
[1.2.18]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_2_12...v_1_2_18
[1.2.12]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_2_4...v_1_2_12
[1.2.4]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_2_2...v_1_2_4
[1.2.2]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_1_58...v_1_2_2
[1.1.58]: https://github.com/LunatikDG/GetManHTTP/releases/tag/v_1_1_58
