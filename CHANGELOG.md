# Changelog

## Version 0.1

### Added

- Initial project structure.
- Git repository.
- Configuration directory.
- Initial `settings.json` configuration file.
- Project documentation.

---

## Version 0.2

### Added

- Configuration loading module.
- JSON configuration parsing.
- Configuration validation.
- Configuration error handling.

### Changed

- Refactored configuration loading into dedicated helper functions.

---

## Version 0.3

### Added

- Refactored PowerShell scripts into reusable `.psm1` modules.
- Replaced script sourcing with `Import-Module`.
- Added explicit module exports using `Export-ModuleMember`.
- Updated project structure to use the `modules/` directory.
- Browser module for launching Playwright automation.
- Node.js integration for browser automation.
- PowerShell → Node.js JSON configuration communication.
- Playwright browser initialization.
- Chromium launch automation.
- Browser context creation with configurable HTTPS handling.
- Configurable viewport support.
- Automated navigation to the configured NVR URL.
- Automated username/password authentication.
- Authenticated browser session established from configuration.

### Changed

- Transitioned browser automation to a configuration-driven architecture.
- Centralized browser behavior through `settings.json`.