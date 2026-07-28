# Changelog

All notable changes to Camera Kiosk Recovery are documented in this file.

The project uses incremental pre-release versions while deployment behavior and long-duration stability are validated.

---

## Version 0.6.2

### Added

- Fullscreen Microsoft Edge window control through a Playwright Chromium DevTools Protocol session.
- Browser window discovery through `Browser.getWindowForTarget`.
- Fullscreen window state enforcement through `Browser.setWindowBounds`.
- Intune package versioning for the corrected deployment payload.

### Changed

- Replaced reliance on browser startup arguments for fullscreen presentation.
- Reduced Edge launch arguments to `--no-first-run`.
- Rebuilt the Intune Win32 package from the synchronized deployment payload.
- Updated the managed deployment from v0.6.1 to v0.6.2.
- Validated package replacement through an Intune-managed uninstall and reinstall cycle.

### Validated

- Edge launches without the visible tab or browser bar.
- The installed JavaScript contains the expected fullscreen implementation.
- The Intune detection marker is recreated after installation.
- The application launches after kiosk sign-in.
- The application continues to recover after Edge is closed.
- The previous package can be removed through Intune before deployment of the replacement.

---

## Version 0.6.1

### Added

- Application-level recovery handling for unexpected browser or Playwright failures.
- Failure logging for browser-launch and browser-session exceptions.
- A five-second delay before retrying unexpected browser failures.

### Changed

- Moved browser recovery ownership into the persistent Node.js automation loop.
- Changed the recovery design so closing Edge no longer depends on Scheduled Task restart behavior.
- Retained Scheduled Task restart settings as a secondary recovery boundary for complete application-process termination.
- Updated `main.ps1` to return a failure when the Node.js automation process ends unexpectedly.
- Synchronized runtime source files into the deployment payload before packaging.

### Fixed

- Prevented browser closure errors from terminating the complete recovery application.
- Prevented immediate uncontrolled browser relaunch loops after unexpected failures.
- Resolved stale deployment-payload files discovered during package validation.

---

## Version 0.6

### Added

- Scheduled Task registration during installation.
- Logon trigger for the local kiosk account.
- Interactive limited-privilege Scheduled Task principal.
- Scheduled Task restart settings.
- Duplicate-instance protection using `IgnoreNew`.
- Intune Win32 application packaging.
- Intune install and uninstall commands.
- File-based Intune detection using `install.complete`.
- Windows 11 Assigned Access deployment validation.
- Managed installation as the SYSTEM account.
- Dedicated deployment-specific application configuration.
- Enterprise installation and update workflow.

### Changed

- Moved startup responsibility from manual execution to a registered Scheduled Task.
- Moved software delivery from manual device setup to Intune.
- Established `C:\ProgramData\Camera-Recovery-Automation` as the permanent installation directory.
- Separated application runtime responsibilities from Windows kiosk and Intune policy responsibilities.

### Validated

- Automatic kiosk sign-in through the surrounding Assigned Access policy.
- Scheduled application launch after kiosk sign-in.
- Intune delivery to the physical kiosk.
- Microsoft Edge execution within the restricted kiosk environment.
- Intune detection and application-status reporting.
- Managed uninstall assignment behavior.

---

## Version 0.5

### Added

- Deployment staging model.
- Portable Windows Node.js runtime support.
- Bundled `node.exe` discovery.
- Fallback to a globally installed Node.js runtime for development.
- Deployment payload validation.
- PowerShell installation script.
- PowerShell uninstallation script.
- Permanent application installation under `C:\ProgramData`.
- Logs-directory creation during installation.
- Kiosk-account log-directory permissions.
- Scheduled Task installation foundation.
- Installation completion marker.
- Selective uninstall behavior.
- Preservation of failure logs during uninstallation.
- PowerShell syntax validation for deployment scripts.
- File-hash validation between source and staged payload files.
- SHA-256 validation of downloaded Node.js runtime files.

### Changed

- Separated source files from the deployable runtime payload.
- Removed the target device’s dependency on a global Node.js installation.
- Updated module paths to remain relative to their installed locations.
- Changed logs from source-development storage to the permanent application directory.
- Treated deployment configuration as deployment-group-specific data.
- Excluded deployment payloads and production configuration from source control.

### Security

- Limited kiosk-account modification rights to the logs directory.
- Kept application files under a SYSTEM-managed ProgramData location.
- Prevented production credentials and deployment payloads from entering the public repository.

### Validated

- Installer syntax under Windows PowerShell 5.1.
- Payload existence checks.
- Bundled Node.js execution.
- Playwright dependency availability.
- Permanent installation paths.
- Log-directory permissions.
- Installer success exit code.
- Uninstaller success exit code.
- Preservation of logs after uninstall.

---

## Version 0.4

### Added

- Continuous browser-session monitoring.
- Video-element health detection.
- Automatic recovery when video is unavailable.
- Continuous browser restart loop.
- Browser lifecycle cleanup using `try...finally`.
- Timestamped console logging.
- Failure-log generation.
- Automatic failure-log retention.
- Maximum retention of 100 failure logs.
- Configurable monitoring interval.

### Changed

- Shifted recovery from modifying a failed browser session to rebuilding the complete browser session.
- Reduced console output to significant application lifecycle events.
- Assigned browser lifecycle ownership to the JavaScript automation layer.

---

## Version 0.3

### Added

- Reusable PowerShell modules.
- Explicit module exports through `Export-ModuleMember`.
- Browser startup module.
- Node.js integration.
- Playwright browser automation.
- PowerShell-to-Node.js JSON communication.
- Configuration transfer through standard input.
- Microsoft Edge launch through Playwright.
- Browser-context creation.
- Configurable HTTPS certificate handling.
- Configurable viewport behavior.
- NVR navigation.
- HTTP credential authentication.
- Authenticated browser-session creation.

### Changed

- Replaced PowerShell script sourcing with `Import-Module`.
- Moved browser behavior into a configuration-driven design.
- Centralized deployment-specific settings in `settings.json`.
- Replaced command-line JSON configuration transfer with standard-input streaming to preserve valid JSON encoding.

### Fixed

- Resolved JSON parsing failures caused by command-line quoting and escaping.
- Improved compatibility between PowerShell and Node.js configuration handling.

---

## Version 0.2

### Added

- Configuration-loading module.
- JSON configuration parsing.
- Required-configuration validation.
- Missing-file handling.
- Invalid-JSON handling.
- Startup error handling.

### Changed

- Refactored configuration loading into dedicated functions.
- Separated configuration responsibilities from the application entry point.

---

## Version 0.1

### Added

- Initial project structure.
- Git repository.
- PowerShell entry point.
- Module organization.
- Configuration directory.
- Initial `settings.json` design.
- README and changelog.