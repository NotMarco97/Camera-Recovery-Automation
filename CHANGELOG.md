# Changelog

## Version 0.1

### Added

- Initial project structure.
- Git repository.
- Configuration directory.
- Empty settings.json for future configuration.
- Project documentation.

## Version 0.2

### Added

- Configuration loading module
- JSON parsing configuration
- Configuration validation
- JSON error handling

Changed
- Refactored configuration loading into dedicated helper functions

## Version 0.3

### Added

- Refactored PowerShell scripts into reusable `.psm1` modules.
- Replaced script sourcing with `Import-Module`.
- Added explicit module exports using `Export-ModuleMember`.
- Updated project structure to use the `modules/` directory.
- Verified PowerShell → Node communication after module refactor.