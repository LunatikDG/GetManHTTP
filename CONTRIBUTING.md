# Contributing to GetManHTTP

<p align="center">
  <a href="#english">🇬🇧 English</a> •
  <a href="#русский">🇷🇺 Русский</a>
</p>

---

<a name="english"></a>
## 🇬🇧 English

Thanks for your interest in improving GetManHTTP. This is a solo-maintained
project, so please read this before opening a PR — it saves both of us time.

### Before you start

- For a **bug fix** or a **small, obviously-scoped change**, feel free to open
  a PR directly.
- For anything **larger** (a new authorization type, import/export, scripting,
  etc.), please open an issue first (or comment on an existing one) describing
  your approach, so it can be discussed before you invest time in an
  implementation that might need to change. Use the
  [feature request template](.github/ISSUE_TEMPLATE/feature_request.yml).
- Questions are welcome via Telegram [@LunatikDG](https://t.me/LunatikDG) or
  <main@lunatikdg.ru> — no need to wait for a formal issue for a quick
  question.

### Project layout

This is a single **external data processor** (`.epf`) for 1C:Enterprise, not a
full configuration:

```
src/ExternalDataProcessors/GetManHTTP/
  GetManHTTP.mdo             — metadata descriptor
  ObjectModule.bsl           — object module
  Forms/Форма/                — main request form + Module.bsl
  Forms/ФормаКоллекцииЗапросов/ — collections form + Module.bsl
  Forms/ФормаНастроек/         — settings form + Module.bsl
```

**Important platform constraint:** an external data processor cannot contain
its own "Общий модуль" (Common Module) — those only exist at the level of a
full 1C configuration. As a result, some logic (notably the authorization
schema registry, `ОписаниеСхемыАвторизации` and its helpers) is intentionally
duplicated between `Forms/Форма/Module.bsl` and
`Forms/ФормаКоллекцииЗапросов/Module.bsl`. If you change one, **change the
other to match** — this isn't an oversight to "clean up" by introducing a
common module; that option doesn't exist here.

### Prerequisites

- **1C:EDT 2025.1.5** and **1C:Enterprise platform 8.3.27** — matching
  `.github/workflows/release.yml`. See the README's
  [Releasing](README.md#releasing-maintainers) section for exact build commands
  (`scripts\build-epf.ps1` / `.cmd`).
- **JDK 21** locally, to run the BSL Language Server lint
  (`scripts\bsl-lint.ps1` / `.cmd` / `.sh`).
- Close 1C:EDT before running the build script (it uses the CLI exporter).

### Code style

- Identifiers (procedure/function/variable names) are in **Russian**,
  matching the rest of the codebase — don't mix in English identifiers for
  new code.
- Commit messages are written in **English**, imperative mood, one concise
  sentence ending with a period — e.g. `Fix Release CI: pin EDT to 2025.1.5
  available in 1C catalog.` Look at `git log` for the established style.
- Run `scripts\bsl-lint.ps1` before pushing. The same check runs in CI
  (`.github/workflows/bsl-lint.yml`) on any push/PR touching `src/**`; a
  failing lint will block the PR check.
- There is currently no automated test suite (BSL doesn't have one set up in
  this project). Test your change manually: load the resulting `.epf` into a
  1C infobase via *File → Open* and exercise the changed feature end to end.
  Note any manual testing you did in the PR description — see the [PR
  template](.github/PULL_REQUEST_TEMPLATE.md).
- If your change touches request execution, test it in **both** Client and
  Server execution context where relevant (see the README's [HTTP execution
  context](README.md#http-execution-context) section) — behavior can differ
  between the two.

### Submitting a pull request

1. Branch off `main`.
2. Keep the PR focused — one logical change per PR is easier to review than a
   bundle of unrelated fixes.
3. Fill out the PR template (description, related issue, testing performed).
4. Update `README.md` (both EN and RU sections) if the change is
   user-visible, and add an entry to `CHANGELOG.md` under `[Unreleased]`.
5. Do **not** bump the version (`ВерсияОбработки()` in
   `Forms/Форма/Module.bsl`) or create a release tag yourself — that's a
   maintainer step described in the README's
   [Releasing](README.md#releasing-maintainers) section, done once a set of changes is
   ready to ship.
6. Don't commit `bin/` or the built `.epf` — it's gitignored and only ever
   produced by the Release CI workflow.

### License

By contributing, you agree that your contribution is licensed under the
project's [GPL-3.0 license](LICENSE.txt).

---

<a name="русский"></a>
## 🇷🇺 Русский

Спасибо за интерес к развитию GetManHTTP. Проект поддерживается одним
разработчиком, поэтому, пожалуйста, прочитайте это перед тем, как открывать
PR — это сэкономит время нам обоим.

### Перед началом работы

- Для **исправления бага** или **небольшого, однозначного по объёму
  изменения** можно сразу открывать PR.
- Для чего-то **более крупного** (новый тип авторизации, импорт/экспорт,
  скрипты и т.п.) — сначала откройте issue (или прокомментируйте
  существующий), опишите свой подход, чтобы его можно было обсудить до того,
  как вы вложите время в реализацию, которую, возможно, придётся менять.
  Используйте [шаблон feature request](.github/ISSUE_TEMPLATE/feature_request.yml).
- Вопросы можно задать в Telegram [@LunatikDG](https://t.me/LunatikDG) или на
  <main@lunatikdg.ru> — необязательно оформлять issue ради короткого вопроса.

### Структура проекта

Это одна **внешняя обработка** (`.epf`) для 1С:Предприятие, а не полноценная
конфигурация:

```
src/ExternalDataProcessors/GetManHTTP/
  GetManHTTP.mdo             — описание метаданных
  ObjectModule.bsl           — модуль объекта
  Forms/Форма/                — основная форма запроса + Module.bsl
  Forms/ФормаКоллекцииЗапросов/ — форма коллекций + Module.bsl
  Forms/ФормаНастроек/         — форма настроек + Module.bsl
```

**Важное платформенное ограничение:** внешняя обработка не может содержать
собственный «Общий модуль» — это объект уровня полноценной конфигурации 1С.
Поэтому часть логики (в первую очередь реестр схем авторизации,
`ОписаниеСхемыАвторизации` и вспомогательные функции) намеренно продублирована
между `Forms/Форма/Module.bsl` и `Forms/ФормаКоллекцииЗапросов/Module.bsl`.
Если меняете одно место — **меняйте и второе синхронно**. Это не недосмотр,
который нужно «убрать» через общий модуль — такой вариант здесь недоступен.

### Требования к окружению

- **1C:EDT 2025.1.5** и платформа **1С:Предприятие 8.3.27** — как в
  `.github/workflows/release.yml`. Точные команды сборки — в разделе
  [Релиз](README.md#релиз-для-мейнтейнеров) README (`scripts\build-epf.ps1` / `.cmd`).
- **JDK 21** локально — для запуска линтера BSL Language Server
  (`scripts\bsl-lint.ps1` / `.cmd` / `.sh`).
- Перед запуском скрипта сборки закройте 1C:EDT (используется CLI-экспортёр).

### Стиль кода

- Идентификаторы (процедуры/функции/переменные) — на **русском языке**, как и
  весь остальной код; не добавляйте англоязычные идентификаторы в новом коде.
- Сообщения коммитов пишутся на **английском языке**, в повелительном
  наклонении, одним лаконичным предложением с точкой в конце — например,
  `Fix Release CI: pin EDT to 2025.1.5 available in 1C catalog.` Ориентируйтесь
  на `git log` — там уже сложившийся стиль.
- Перед push запускайте `scripts\bsl-lint.ps1`. Та же проверка выполняется в
  CI (`.github/workflows/bsl-lint.yml`) при push/PR, затрагивающих `src/**`;
  ошибки линтера блокируют проверку PR.
- Автоматических тестов в проекте пока нет. Проверяйте изменение вручную:
  загрузите получившийся `.epf` в информационную базу 1С через *Файл →
  Открыть* и пройдите изменённый сценарий целиком. Опишите, что именно
  тестировали вручную, в описании PR — см. [шаблон
  PR](.github/PULL_REQUEST_TEMPLATE.md).
- Если изменение касается выполнения запроса — проверьте его в **обоих**
  контекстах выполнения (Клиент и Сервер), если это применимо (см. раздел
  README [Контекст выполнения HTTP](README.md#контекст-выполнения-http)) —
  поведение может отличаться.

### Оформление Pull Request

1. Создавайте ветку от `main`.
2. Держите PR сфокусированным — одно логическое изменение в PR проще
   ревьюить, чем набор несвязанных правок.
3. Заполните шаблон PR (описание, связанный issue, что тестировали).
4. Обновите `README.md` (обе секции — EN и RU), если изменение затрагивает
   пользователя, и добавьте запись в `CHANGELOG.md` в раздел `[Unreleased]`.
5. **Не поднимайте версию** (`ВерсияОбработки()` в `Forms/Форма/Module.bsl`) и
   не создавайте тег релиза самостоятельно — это шаг мейнтейнера, описанный в
   разделе README [Релиз](README.md#релиз-для-мейнтейнеров), выполняется, когда набор
   изменений готов к выпуску.
6. Не коммитьте `bin/` или собранный `.epf` — каталог в `.gitignore`, файл
   собирается только CI-воркфлоу релиза.

### Лицензия

Внося изменения, вы соглашаетесь, что ваш вклад распространяется по лицензии
проекта [GPL-3.0](LICENSE.txt).
