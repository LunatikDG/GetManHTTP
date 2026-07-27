# Security Policy

<p align="center">
  <a href="#english">English</a> •
  <a href="#русский">Русский</a>
</p>

---

<a name="english"></a>

## English

Thank you for helping keep **GetManHTTP** safe for everyone.

### Supported versions

Security fixes are provided for the **latest [release](https://github.com/LunatikDG/GetManHTTP/releases)** only. Older `.epf` builds are not maintained.

### How to report a vulnerability

**Please do not open a public GitHub Issue** for security problems (credentials, exploit steps, or sensitive URLs).

Preferred:

1. **[Private vulnerability report](https://github.com/LunatikDG/GetManHTTP/security/advisories/new)** on GitHub (if enabled for this repository), or
2. Email **main@lunatikdg.ru** with subject `GetManHTTP security`.

Include, when possible:

- Affected version (release tag or `.epf` name)
- Steps to reproduce
- Impact (e.g. credential exposure, unsafe TLS, unexpected request behavior)
- Any proof-of-concept kept **private** until we agree on disclosure

We will acknowledge receipt as soon as practicable and work on a fix. Coordinated disclosure is appreciated; we ask for reasonable time before public details.

### In scope

- The GetManHTTP external data processor (sources in this repo and official release artifacts)
- Handling of HTTP/HTTPS, TLS, stored settings, and authorization data (Basic / Bearer) within the processor

### Out of scope

- Vulnerabilities in **1C:Enterprise** or third-party platforms
- Issues caused only by misconfiguration or user-supplied endpoints (e.g. sending secrets to untrusted URLs)
- Denial-of-service against arbitrary external servers without a flaw in GetManHTTP itself

### Safe use

This tool can send requests to URLs you choose and may persist headers and tokens in form settings. Use only in environments where external processors are permitted, and avoid storing production secrets on shared machines.

---

<a name="русский"></a>

## Русский

Спасибо, что помогаете сделать **GetManHTTP** безопаснее.

### Поддерживаемые версии

Исправления безопасности выпускаются только для **последнего [релиза](https://github.com/LunatikDG/GetManHTTP/releases)**. Более старые сборки `.epf` не поддерживаются.

### Как сообщить об уязвимости

**Не создавайте публичный Issue** для проблем безопасности (учётные данные, шаги эксплуатации, чувствительные URL).

Предпочтительно:

1. **[Приватное сообщение об уязвимости](https://github.com/LunatikDG/GetManHTTP/security/advisories/new)** на GitHub, или
2. Письмо на **main@lunatikdg.ru** с темой `GetManHTTP security`.

По возможности укажите:

- Версию (тег релиза или имя `.epf`)
- Шаги воспроизведения
- Влияние (утечка секретов, небезопасный TLS, неожиданное поведение запросов)
- PoC держите **приватным**, пока не согласуем публикацию

Мы постараемся подтвердить получение и подготовить исправление. Ценим согласованное раскрытие и просим разумный срок до публичных деталей.

### В зоне ответственности

- Внешняя обработка GetManHTTP (исходники в репозитории и официальные артефакты релизов)
- Работа с HTTP/HTTPS, TLS, сохранёнными настройками и данными авторизации (Basic / Bearer) внутри обработки

### Вне зоны ответственности

- Уязвимости **платформы 1С:Предприятие** и сторонних систем
- Случаи, когда проблема вызвана только настройками или вводом пользователя (например, отправка секретов на недоверенные URL)
- Отказ в обслуживании произвольных внешних серверов без ошибки в самой GetManHTTP

### Безопасное использование

Обработка выполняет запросы по указанным вами адресам и может сохранять заголовки и токены в настройках формы. Используйте только там, где разрешены внешние обработки, и не храните боевые секреты на общих рабочих местах.
