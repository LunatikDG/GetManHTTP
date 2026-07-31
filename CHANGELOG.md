# Changelog

All notable changes to **GetManHTTP** are documented in this file.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions correspond to git tags (`v_X_Y_Z` tag → `X.Y.Z` version); see
[Releasing](README.md#installation) in the README for how releases are cut.
Entries are written in English regardless of the (bilingual) README, matching
the language already used in this repository's commit history.

## [Unreleased]

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

[Unreleased]: https://github.com/LunatikDG/GetManHTTP/compare/v_1_3_22...HEAD
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
