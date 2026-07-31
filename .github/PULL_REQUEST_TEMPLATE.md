<!--
Спасибо за PR! Пожалуйста, заполните шаблон ниже — это ускорит ревью.
Thanks for the PR! Please fill in the template below — it speeds up review.
See CONTRIBUTING.md before opening a large change.
-->

## Описание / Description

<!-- Что меняется и зачем. / What changes and why. -->



## Связанный issue / Related issue

<!-- Closes #123 — если применимо. / Closes #123 — if applicable. -->



## Тип изменения / Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation only
- [ ] CI / build
- [ ] Other (describe above)

## Как тестировалось / How this was tested

<!--
Автотестов в проекте нет — опишите ручную проверку: какой .epf версии,
какой клиент 1С (толстый/тонкий/веб), какой сценарий прошли.

There's no automated test suite in this project — describe the manual check:
which .epf build, which 1C client (thick/thin/web), which scenario you ran.
-->

- Версия 1С / 1C platform version:
- Клиент / Client: <!-- толстый / тонкий / веб — thick / thin / web -->
- Execution context (Client / Server), если применимо / if applicable:
- Сценарий проверки / Test scenario:

## Чеклист / Checklist

- [ ] `scripts\bsl-lint.ps1` пройден без новых замечаний / passes with no new findings
- [ ] Проверено вручную в 1С (см. выше) / Manually verified in 1C (see above)
- [ ] README.md обновлён (EN + RU), если изменение видно пользователю / updated if user-facing
- [ ] Запись добавлена в `CHANGELOG.md` под `[Unreleased]` / entry added under `[Unreleased]`
- [ ] `bin/` и `.epf` не закоммичены / not committed
- [ ] Версия (`ВерсияОбработки()`) не поднята — это шаг мейнтейнера / version not bumped — that's a maintainer step
