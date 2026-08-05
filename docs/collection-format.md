# GetManHTTP Collection Format

<p align="center">
  <a href="#english">English</a> •
  <a href="#русский">Русский</a>
</p>

---

<a name="english"></a>

## English

Specification of the **native** collection interchange format used by GetManHTTP
import/export (`format` = `GetManHTTP.Collection`). This is **not** the Postman
Collection v2.1 shape; Postman files are detected separately and mapped into the
same in-memory model.

| | |
| --- | --- |
| **Format id** | `GetManHTTP.Collection` |
| **Current schema version** | `1` |
| **Encoding** | UTF-8 JSON object |
| **Source of truth** | `Forms/Форма/Module.bsl` region `#Область ИмпортЭкспортКоллекций` |

### Versioning and compatibility

- Exporters always write `schemaVersion` equal to the current version (`1`).
- Importers **reject** files whose `schemaVersion` is **greater** than the
  version supported by the running build.
- Lower or equal versions of schema `1` are accepted; missing optional fields
  use the defaults described below.
- A future breaking change MUST bump `schemaVersion`. Additive fields in the
  same major schema SHOULD remain optional with safe defaults.

### Detection

A file is treated as a native collection when the root object has:

```json
"format": "GetManHTTP.Collection"
```

Otherwise GetManHTTP may try Postman Collection v2.1 (`info.schema` / `item`).
Anything else is rejected.

### Import semantics

- Collections and tree items are keyed by `id` (UUID string).
- If a collection with the same `id` already exists, the UI asks for
  confirmation and then **replaces** that collection (settings + full request
  tree).
- Empty `id` values are generated on import (`Новый УникальныйИдентификатор`).
- Empty `name` values fall back to product defaults (“New collection”, “Folder”,
  “Request”, …).
- Secrets in `auth.params` are stored **in plaintext** in the JSON file — treat
  exported files as credentials.

### Root object

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `format` | string | **yes** | Must be `GetManHTTP.Collection`. |
| `schemaVersion` | number | **yes** | Schema version; currently `1`. |
| `id` | string | recommended | Collection UUID. Generated if empty. |
| `name` | string | recommended | Display name. |
| `timeout` | object | no | Collection HTTP timeout. Default: use platform default. |
| `auth` | [Auth](#auth-en) | no | Collection-level auth. Default type: `NoAuth`. |
| `items` | array of [Item](#item-en) | no | Root folders and requests (ordered). |

#### `timeout`

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `useDefault` | boolean | `true` | When `true`, ignore `seconds` and use the processing default timeout. |
| `seconds` | number | `0` | Timeout in seconds when `useDefault` is `false`. |

---

<a name="auth-en"></a>

### Auth

Portable authorization object (collection, folder, or request).

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | string | recommended | Auth type id (see table). Unknown values fall back to the context default. |
| `params` | array of AuthParam | no | Key/value parameters for the type. |

#### AuthParam

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | string | `""` | Parameter name (schema key, not HTTP header name unless type says so). |
| `value` | string | `""` | Parameter value. |
| `secret` | boolean | `false` | UI hint: mask the value. |

#### Auth types and expected `params` keys

| `type` | Allowed on | `params` keys | Notes |
| --- | --- | --- | --- |
| `NoAuth` | collection, folder, request | _(none)_ | Explicitly disable auth. |
| `BasicAuth` | collection, folder, request | `login`, `password` | HTTP Basic. `password` is secret. |
| `Token` | collection, folder, request | `tokenPrefix`, `token` | Sent as `Authorization: {tokenPrefix} {token}`. Default prefix when empty at apply time: `Token`. `token` is secret. |
| `BearerToken` | collection, folder, request | `token` | Sent as `Authorization: Bearer {token}` (fixed prefix, RFC 6750). `token` is secret. |
| `ApiKey` | collection, folder, request | `key`, `value`, `addTo` | `addTo`: `Header` (default) or `Query`. Default `key` name: `X-API-Key`. `value` is secret. |
| `InheritFromOwner` | folder, request | _(none)_ | Walk up folder → collection auth. **Not** valid as collection root auth (importers coerce unsupported types to the context default). |

---

<a name="item-en"></a>

### Item

Every entry in `items` / `children` has:

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `id` | string | recommended | Item UUID. |
| `name` | string | recommended | Display name. |
| `type` | string | **yes** | `folder` or `request` (case-insensitive on import). |

#### Folder (`type` = `"folder"`)

| Field | Type | Description |
| --- | --- | --- |
| `auth` | Auth | Folder auth; default type `InheritFromOwner`. |
| `children` | array of Item | Nested folders and requests. |

#### Request (`type` = `"request"`)

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `method` | string | `GET` | HTTP method (stored uppercased). |
| `url` | string | `""` | Request URL / URI (query string may also be mirrored in `query`). |
| `sendMode` | string | `Клиент` | Execution context: `Клиент` or `Сервер`. |
| `auth` | Auth | `InheritFromOwner` | Request auth. |
| `headers` | array of KeyValue | `[]` | Request headers. |
| `query` | array of KeyValue | `[]` | Query parameters. |
| `body` | Body | see below | Request body. |

Responses, scripts, tests, and environments are **out of scope** for schema v1
(not exported).

#### KeyValue (`headers` / `query`)

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | string | | Name. |
| `value` | string | | Value. |
| `description` | string | omitted | Optional comment. |
| `disabled` | boolean | omitted/`false` | When `true`, row is inactive (`Активен = false`). |
| `auto` | boolean | omitted/`false` | **Headers only.** When `true`, row is managed by the client from body mode / defaults (`Автоматический`). Omitted or `false` means a manual header that sync must not overwrite. Ignored for `query`. |

#### Body

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | string | `NONE` | Body mode (see table). Unsupported values become `NONE`. |
| `raw` | string | `""` | Text body for `JSON` / `XML`. |
| `filePath` | string | `""` | Local path for `BINARY` (machine-specific; may not transfer). |
| `formData` | array of FormDataField | `[]` | Fields for `FORM_DATA`. |

| `mode` | Meaning |
| --- | --- |
| `NONE` | No body. |
| `JSON` | Raw JSON text in `raw`. |
| `XML` | Raw XML text in `raw`. |
| `FORM_DATA` | Multipart/form fields in `formData`. |
| `BINARY` | File upload from `filePath`. |

#### FormDataField

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `key` | string | | Field name (`name` in Content-Disposition). |
| `type` | string | `text` | `text` or `file`. |
| `value` | string | `""` | Text value when `type` is `text`. |
| `src` | string | omitted | Local file path when `type` is `file` (machine-specific). |
| `contentType` | string | omitted | Part Content-Type; if empty, inferred from the file extension (`application/octet-stream` fallback). |
| `description` | string | omitted | Optional comment. |

Multipart bodies are built as binary; total in-memory size is capped at **50 MB**.

### Minimal example

```json
{
  "format": "GetManHTTP.Collection",
  "schemaVersion": 1,
  "id": "11111111-1111-1111-1111-111111111111",
  "name": "Demo API",
  "timeout": {
    "useDefault": true,
    "seconds": 0
  },
  "auth": {
    "type": "NoAuth",
    "params": []
  },
  "items": [
    {
      "id": "22222222-2222-2222-2222-222222222222",
      "name": "Health",
      "type": "request",
      "method": "GET",
      "url": "https://example.com/health",
      "sendMode": "Клиент",
      "auth": {
        "type": "InheritFromOwner",
        "params": []
      },
      "headers": [],
      "query": [],
      "body": {
        "mode": "NONE",
        "raw": "",
        "filePath": "",
        "formData": []
      }
    }
  ]
}
```

### Example with API Key and folder

```json
{
  "format": "GetManHTTP.Collection",
  "schemaVersion": 1,
  "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "name": "Payments",
  "timeout": { "useDefault": false, "seconds": 30 },
  "auth": {
    "type": "ApiKey",
    "params": [
      { "key": "key", "value": "X-API-Key", "secret": false },
      { "key": "value", "value": "secret-token", "secret": true },
      { "key": "addTo", "value": "Header", "secret": false }
    ]
  },
  "items": [
    {
      "id": "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb",
      "name": "v1",
      "type": "folder",
      "auth": { "type": "InheritFromOwner", "params": [] },
      "children": [
        {
          "id": "cccccccc-cccc-cccc-cccc-cccccccccccc",
          "name": "Create payment",
          "type": "request",
          "method": "POST",
          "url": "https://api.example.com/v1/payments",
          "sendMode": "Сервер",
          "auth": { "type": "InheritFromOwner", "params": [] },
          "headers": [
            { "key": "Content-Type", "value": "application/json" }
          ],
          "query": [],
          "body": {
            "mode": "JSON",
            "raw": "{\"amount\":100}",
            "filePath": "",
            "formData": []
          }
        }
      ]
    }
  ]
}
```

### Related formats

- **Postman Collection v2.1** — also importable/exportable from the same UI;
  mapping is lossy for unsupported Postman features (scripts, saved responses,
  JWT, …). That interchange is **not** defined by this document.

---

<a name="русский"></a>

## Русский

Спецификация **нативного** формата обмена коллекциями GetManHTTP
(`format` = `GetManHTTP.Collection`). Это **не** формат Postman Collection
v2.1: файлы Postman определяются отдельно и преобразуются во внутреннюю модель.

| | |
| --- | --- |
| **Идентификатор формата** | `GetManHTTP.Collection` |
| **Текущая версия схемы** | `1` |
| **Кодировка** | JSON-объект в UTF-8 |
| **Источник истины в коде** | `Forms/Форма/Module.bsl`, область `#Область ИмпортЭкспортКоллекций` |

### Версионирование и совместимость

- При экспорте всегда записывается текущий `schemaVersion` (`1`).
- Импорт **отклоняет** файлы с `schemaVersion` **больше**, чем поддерживает
  запущенная сборка.
- Та же или меньшая версия схемы `1` принимается; отсутствующие необязательные
  поля заполняются значениями по умолчанию (см. ниже).
- Ломающее изменение формата **обязано** увеличить `schemaVersion`. Добавление
  полей в рамках той же схемы должно оставаться необязательным с безопасными
  значениями по умолчанию.

### Распознавание

Файл считается нативной коллекцией, если в корне есть:

```json
"format": "GetManHTTP.Collection"
```

Иначе возможна попытка разобрать Postman Collection v2.1 (`info.schema` /
`item`). Любой другой вид файла отклоняется.

### Семантика импорта

- Коллекции и элементы дерева идентифицируются по `id` (строка UUID).
- Если коллекция с таким `id` уже есть, UI запрашивает подтверждение и затем
  **заменяет** коллекцию (настройки + всё дерево запросов).
- Пустой `id` при импорте генерируется (`Новый УникальныйИдентификатор`).
- Пустое `name` подменяется значениями по умолчанию продукта.
- Секреты в `auth.params` хранятся в JSON **открытым текстом** — экспортированные
  файлы нужно считать носителями учётных данных.

### Корневой объект

| Поле | Тип | Обязательно | Описание |
| --- | --- | --- | --- |
| `format` | string | **да** | Должно быть `GetManHTTP.Collection`. |
| `schemaVersion` | number | **да** | Версия схемы; сейчас `1`. |
| `id` | string | рекомендуется | UUID коллекции. Если пусто — генерируется. |
| `name` | string | рекомендуется | Отображаемое имя. |
| `timeout` | object | нет | Таймаут HTTP коллекции. По умолчанию — таймаут обработки. |
| `auth` | [Auth](#auth-ru) | нет | Авторизация уровня коллекции. Тип по умолчанию: `NoAuth`. |
| `items` | массив [Item](#item-ru) | нет | Корневые папки и запросы (с сохранением порядка). |

#### `timeout`

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `useDefault` | boolean | `true` | При `true` поле `seconds` игнорируется. |
| `seconds` | number | `0` | Таймаут в секундах, если `useDefault` = `false`. |

---

<a name="auth-ru"></a>

### Auth

Портативный объект авторизации (коллекция, папка или запрос).

| Поле | Тип | Обязательно | Описание |
| --- | --- | --- | --- |
| `type` | string | рекомендуется | Идентификатор типа (см. таблицу). Неизвестный тип → значение по умолчанию для контекста. |
| `params` | массив AuthParam | нет | Параметры типа. |

#### AuthParam

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `key` | string | `""` | Имя параметра схемы. |
| `value` | string | `""` | Значение. |
| `secret` | boolean | `false` | Подсказка UI: маскировать значение. |

#### Типы авторизации и ключи `params`

| `type` | Где допустим | Ключи `params` | Примечание |
| --- | --- | --- | --- |
| `NoAuth` | коллекция, папка, запрос | _(нет)_ | Явно без авторизации. |
| `BasicAuth` | коллекция, папка, запрос | `login`, `password` | HTTP Basic. `password` — секрет. |
| `Token` | коллекция, папка, запрос | `tokenPrefix`, `token` | Заголовок `Authorization: {tokenPrefix} {token}`. Префикс по умолчанию при применении: `Token`. `token` — секрет. |
| `BearerToken` | коллекция, папка, запрос | `token` | Заголовок `Authorization: Bearer {token}` (фиксированный префикс, RFC 6750). `token` — секрет. |
| `ApiKey` | коллекция, папка, запрос | `key`, `value`, `addTo` | `addTo`: `Header` (по умолчанию) или `Query`. Имя ключа по умолчанию: `X-API-Key`. `value` — секрет. |
| `InheritFromOwner` | папка, запрос | _(нет)_ | Наследование папка → коллекция. На корне коллекции не используется. |

---

<a name="item-ru"></a>

### Item

Каждый элемент `items` / `children`:

| Поле | Тип | Обязательно | Описание |
| --- | --- | --- | --- |
| `id` | string | рекомендуется | UUID элемента. |
| `name` | string | рекомендуется | Отображаемое имя. |
| `type` | string | **да** | `folder` или `request` (при импорте без учёта регистра). |

#### Папка (`type` = `"folder"`)

| Поле | Тип | Описание |
| --- | --- | --- |
| `auth` | Auth | Авторизация папки; тип по умолчанию `InheritFromOwner`. |
| `children` | массив Item | Вложенные папки и запросы. |

#### Запрос (`type` = `"request"`)

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `method` | string | `GET` | HTTP-метод (сохраняется в верхнем регистре). |
| `url` | string | `""` | URL / URI. |
| `sendMode` | string | `Клиент` | Контекст выполнения: `Клиент` или `Сервер`. |
| `auth` | Auth | `InheritFromOwner` | Авторизация запроса. |
| `headers` | массив KeyValue | `[]` | Заголовки. |
| `query` | массив KeyValue | `[]` | Параметры строки запроса. |
| `body` | Body | см. ниже | Тело запроса. |

Ответы, скрипты, тесты и окружения в схему v1 **не входят**.

#### KeyValue (`headers` / `query`)

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `key` | string | | Имя. |
| `value` | string | | Значение. |
| `description` | string | отсутствует | Необязательный комментарий. |
| `disabled` | boolean | отсутствует/`false` | При `true` строка неактивна. |
| `auto` | boolean | отсутствует/`false` | **Только для headers.** При `true` строка управляется клиентом по типу тела / умолчаниям (`Автоматический`). Отсутствие или `false` — ручной заголовок, синхронизатор его не перезаписывает. Для `query` игнорируется. |

#### Body

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `mode` | string | `NONE` | Режим тела (см. таблицу). Неподдерживаемые значения → `NONE`. |
| `raw` | string | `""` | Текст для `JSON` / `XML`. |
| `filePath` | string | `""` | Локальный путь для `BINARY` (привязан к машине). |
| `formData` | массив FormDataField | `[]` | Поля для `FORM_DATA`. |

| `mode` | Смысл |
| --- | --- |
| `NONE` | Без тела. |
| `JSON` | JSON-текст в `raw`. |
| `XML` | XML-текст в `raw`. |
| `FORM_DATA` | Поля multipart в `formData`. |
| `BINARY` | Файл из `filePath`. |

#### FormDataField

| Поле | Тип | По умолчанию | Описание |
| --- | --- | --- | --- |
| `key` | string | | Имя поля (`name` в Content-Disposition). |
| `type` | string | `text` | `text` или `file`. |
| `value` | string | `""` | Текст при `type` = `text`. |
| `src` | string | отсутствует | Локальный путь к файлу при `type` = `file` (привязан к машине). |
| `contentType` | string | отсутствует | Content-Type части; если пусто — по расширению файла (иначе `application/octet-stream`). |
| `description` | string | отсутствует | Необязательный комментарий. |

Тело multipart собирается в двоичном виде; суммарный размер в памяти ограничен **50 МБ**.

### Минимальный пример

См. JSON в английской секции [Minimal example](#minimal-example) — структура
одинакова для обеих локалей.

### Связанные форматы

- **Postman Collection v2.1** — также импортируется/экспортируется из того же
  UI; преобразование с потерями для неподдерживаемых возможностей Postman.
  Этот обмен **не** описывается данным документом.
