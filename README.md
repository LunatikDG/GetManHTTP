# HTTP-client for 1C:Enterprise

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue)](https://github.com/LunatikDG/GetManHTTP/blob/main/LICENSE)
[![1C Version](https://img.shields.io/badge/1С-8.3.26%2B-orange)](#)
[![Release](https://img.shields.io/badge/release-1.1.58-red)](https://github.com/LunatikDG/GetManHTTP/releases)

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
- Custom headers and query parameters
- JSON and XML request body support
- Binary file upload support
- Response and status code handling
- Save response body to a file
- Authorization support (Basic, Bearer Token)
- HTTPS support
- Persists the last used data in the processor between 1C sessions
- Auto-save every 30 seconds while the form is open
- Safe settings persistence on form close (skips save on platform shutdown)
- Request execution time measurement
- Detailed response inspection (response headers, status code, request body)
- Automatic JSON/XML response formatting

### Installation

1. Download the [latest release](https://github.com/LunatikDG/GetManHTTP/releases)
2. Load the external data processor into your 1C configuration via
   *File → Open*

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
- Передача заголовков и параметров
- Поддержка JSON- и XML-тел запросов
- Отправка двоичных файлов
- Обработка ответа и кода состояния
- Сохранение тела ответа в файл
- Работа с авторизацией (Basic, Bearer Token)
- Поддержка HTTPS
- Сохраняет последние данные в обработке при выходе из 1С
- Автосохранение каждые 30 секунд при открытой форме
- Безопасное сохранение настроек при закрытии (без ошибки при завершении работы платформы)
- Поддержка замера времени выполнения запроса
- Отображение детальной информации результата запроса (заголовки ответа,
  код ответа, тело запроса)
- Автоматическое форматирование JSON/XML в ответе

### Установка

1. Скачайте [последний релиз](https://github.com/LunatikDG/GetManHTTP/releases)
2. Загрузите обработку в конфигурацию 1С через *Файл → Открыть*

### Требования

- 1С:Предприятие 8.3.26 (на более ранних версиях не тестировалось) и выше
- Доступ в интернет
- Разрешение на использование внешних обработок

### Связь

Замечания, пожелания и обратную связь можно отправить по следующим
контактам:

- Почта: <main@lunatikdg.ru>
- Telegram: [@LunatikDG](https://t.me/LunatikDG)
