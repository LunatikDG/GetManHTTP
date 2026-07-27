# HTTP-client for 1C:Enterprise

[![License](https://img.shields.io/badge/license-GPL--3.0-blue)](https://github.com/LunatikDG/GetManHTTP/blob/main/LICENSE.txt)
[![1C Version](https://img.shields.io/badge/1С-8.3.26%2B-orange)](#)
[![Release](https://img.shields.io/badge/release-1.3.4-red)](https://github.com/LunatikDG/GetManHTTP/releases)

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

### Installation

1. Download the [latest release](https://github.com/LunatikDG/GetManHTTP/releases)
2. Load the external data processor into your 1C configuration via
   *File → Open*

### Releasing (maintainers)

1. Build `bin/GetManHTTP_v_X_Y_Z.epf` and commit it with the sources
2. Create and push a tag: `git tag -a v_X_Y_Z -m "GetManHTTP vX.Y.Z"` then `git push origin v_X_Y_Z`
3. GitHub Actions creates the release and attaches the `.epf`

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

### Установка

1. Скачайте [последний релиз](https://github.com/LunatikDG/GetManHTTP/releases)
2. Загрузите обработку в конфигурацию 1С через *Файл → Открыть*

### Релиз (для мейнтейнеров)

1. Соберите `bin/GetManHTTP_v_X_Y_Z.epf` и закоммитьте вместе с исходниками
2. Создайте и запушьте тег: `git tag -a v_X_Y_Z -m "GetManHTTP vX.Y.Z"` затем `git push origin v_X_Y_Z`
3. GitHub Actions создаст релиз и приложит `.epf`

### Требования

- 1С:Предприятие 8.3.26 (на более ранних версиях не тестировалось) и выше
- Доступ в интернет
- Разрешение на использование внешних обработок

### Связь

Замечания, пожелания и обратную связь можно отправить по следующим
контактам:

- Почта: <main@lunatikdg.ru>
- Telegram: [@LunatikDG](https://t.me/LunatikDG)
