# Camera Kiosk Recovery

Camera Kiosk Recovery is a Windows kiosk automation application that maintains an authenticated NVR browser session without requiring user interaction.

The application launches Microsoft Edge through Playwright, connects to a configured NVR, monitors the video session, and automatically rebuilds the browser session after a browser closure, session failure, missing video feed, or other interruption.

## Technology Stack

### Runtime
- Windows PowerShell 5.1
- Node.js
- JavaScript
- Microsoft Playwright
- Microsoft Edge (Chromium)

### Deployment
- Microsoft Intune (Win32 Applications)
- Microsoft Win32 Content Prep Tool (IntuneWinAppUtil)
- Windows Task Scheduler

### Configuration
- JSON

## Current Status

**Current version:** v0.6.2  
**Deployment status:** Successfully deployed and validated on an Intune-managed Windows 11 kiosk.

The application currently supports:

- Configuration loading and validation.
- Authenticated NVR navigation.
- Microsoft Edge automation through Playwright.
- Fullscreen browser presentation.
- Continuous video-session monitoring.
- Automatic browser-session recovery.
- Failure logging and log retention.
- Portable Node.js execution.
- Scheduled startup after kiosk sign-in.
- Intune Win32 application deployment.
- Managed installation, detection, updates, and uninstallation.


---

## Purpose

The project was created to eliminate repeated manual intervention on a camera kiosk.

A kiosk session may be interrupted by:

- Device reboots.
- Microsoft Edge being closed.
- Browser crashes.
- NVR session expiration.
- Temporary network interruptions.
- Missing or unavailable video elements.
- Unexpected automation failures.

Camera Kiosk Recovery automatically restores the browser session when one of these conditions interrupts normal operation.

---

## Design

The project is separated into two models:

1. The **application runtime model**, which performs and monitors the NVR automation.
2. The **enterprise deployment model**, which installs, starts, detects, updates, and removes the application.

Keeping these models separate prevents the browser-recovery logic from becoming dependent on Intune or a particular kiosk policy.

### Model 1 — Application Runtime

```text
main.ps1
    │
    ├── Load and validate settings.json
    │
    └── Start Browser.psm1
              │
              ├── Select bundled node.exe
              ├── Convert configuration to JSON
              └── Send configuration through standard input
                           │
                           ▼
                  launchBrowser.js
                           │
                           ├── Launch Microsoft Edge
                           ├── Create authenticated browser context
                           ├── Navigate to configured NVR
                           ├── Set browser window to fullscreen
                           └── Monitor the video element
                                      │
                       ┌──────────────┴──────────────┐
                       │                             │
                  Video healthy               Session failure
                       │                             │
                 Continue monitoring          Save failure log
                                                     │
                                              Close browser session
                                                     │
                                              Wait when appropriate
                                                     │
                                              Launch a new session
```

The JavaScript recovery loop owns browser-session recovery. Closing Edge does not need to terminate the complete application. Instead, the application detects the closed browser, records the failure, and starts another browser session.

If the Node.js application itself exits unexpectedly, `main.ps1` returns a failure. The Scheduled Task can then provide a second recovery boundary.

### Model 2 — Enterprise Deployment

```text
Source repository
      │
      ├── PowerShell source
      ├── JavaScript source
      ├── configuration template
      └── dependency manifests
              │
              ▼
       Local deployment payload
              │
              ├── Application files
              ├── Deployment-specific settings.json
              ├── Portable node.exe
              └── Installed node_modules
                      │
                      ▼
              IntuneWinAppUtil
                      │
                      ▼
             .intunewin package
                      │
                      ▼
               Microsoft Intune
                      │
                      ├── Install as SYSTEM
                      ├── Copy payload to ProgramData
                      ├── Create writable log directory
                      ├── Grant kiosk log permissions
                      ├── Register Scheduled Task
                      └── Create install.complete
                              │
                              ▼
                       Kiosk user signs in
                              │
                              ▼
                    Scheduled Task starts app
```

Intune owns package delivery and assignment. The installer owns the permanent installation, log permissions, Scheduled Task, and detection marker. The application remains responsible only for NVR session behavior.

---

## Recovery Boundaries

The project uses two recovery boundaries.

### Browser-session recovery

`launchBrowser.js` continuously owns the browser lifecycle.

When the video disappears or the browser closes:

1. The failure is detected.
2. A failure log is created.
3. The browser context is cleaned up.
4. A new browser session is launched.
5. The application reconnects to the NVR.

### Application-process recovery

The Scheduled Task starts `main.ps1` when the kiosk account signs in.

If the complete PowerShell/Node.js application exits unexpectedly, the Scheduled Task is configured to attempt a restart. This is a fallback for application-level termination, not the primary mechanism for normal browser recovery.

---

## Project Structure

```text
Camera-Recovery-Automation
├── CHANGELOG.md
├── README.md
├── config
│   └── settings.example.json
├── deployment
│   ├── install.ps1
│   └── uninstall.ps1
├── docs
│   └── deployment.md
├── package.json
├── package-lock.json
├── scripts
│   └── launchBrowser.js
└── src
    ├── main.ps1
    └── modules
        ├── Browser.psm1
        └── Configuration.psm1
```

The following runtime content is intentionally excluded from the public repository:

```text
deployment/payload/
config/settings.json
node_modules/
runtime/node.exe
generated logs
*.intunewin
```

---

## Component Responsibilities

### `src/main.ps1`

The PowerShell entry point:

- Imports the configuration and browser modules.
- Loads the application configuration.
- starts the Node.js automation process.
- Returns a failure if the complete automation process stops unexpectedly.

### `Configuration.psm1`

Responsible for:

- Locating `config/settings.json`.
- Reading the configuration file.
- Parsing JSON.
- Validating required credentials.
- Returning the configuration object.

### `Browser.psm1`

Responsible for:

- Locating `launchBrowser.js`.
- Selecting the bundled Node.js runtime when available.
- Falling back to a globally installed Node.js runtime for development.
- Serializing the PowerShell configuration.
- Sending configuration to Node.js through standard input.

### `launchBrowser.js`

Responsible for:

- Reading configuration from standard input.
- Launching Microsoft Edge through Playwright.
- Creating an authenticated browser context.
- Navigating to the configured NVR.
- Setting the Edge window to fullscreen.
- Monitoring the first visible video element.
- Restarting failed browser sessions.
- Recording and retaining failure logs.

### `deployment/install.ps1`

Responsible for:

- Validating the deployment payload.
- Copying the payload into the permanent installation directory.
- Creating the logs directory.
- Granting the kiosk account permission to write logs.
- Registering the Scheduled Task.
- Creating the Intune detection marker after successful installation.

### `deployment/uninstall.ps1`

Responsible for:

- Stopping and unregistering the Scheduled Task.
- Removing application runtime files.
- Removing configuration and the detection marker.
- Preserving failure logs for later IT review.

---

## Configuration

Create a deployment-specific file named:

```text
config/settings.json
```

Use `config/settings.example.json` as the template:

```json
{
    "url": "https://nvr.example.local",
    "username": "your-username",
    "password": "your-password",
    "ignoreHttpsErrors": true,
    "headless": false,
    "viewportMode": "host",
    "monitorIntervalSeconds": 5
}
```

### Configuration fields

| Field | Purpose |
|---|---|
| `url` | Address of the NVR web interface |
| `username` | NVR authentication username |
| `password` | NVR authentication password |
| `ignoreHttpsErrors` | Allows deployment with an internally managed or untrusted certificate |
| `headless` | Controls whether Edge is visible |
| `viewportMode` | Uses the host window dimensions when set to `host` |
| `monitorIntervalSeconds` | Time between video-health checks |

Production credentials must never be committed to source control.

---

## Runtime Requirements

### Target device

- Windows 11 x64.
- Windows PowerShell 5.1.
- Microsoft Edge.
- An existing local kiosk account.
- Network access to the configured NVR.
- An applicable Windows Assigned Access policy.

### Deployment payload

The local payload used to build the Intune package contains:

- PowerShell application files.
- JavaScript automation file.
- Deployment-specific `settings.json`.
- Portable `node.exe`.
- Installed `node_modules`.
- `package.json` and `package-lock.json`.

The target kiosk does not require a manual Node.js or PowerShell 7 installation.

---

## Installation Location

The application is installed under:

```text
C:\ProgramData\Camera-Recovery-Automation
```

Failure logs are stored under:

```text
C:\ProgramData\Camera-Recovery-Automation\scripts\logs
```

The Intune detection marker is:

```text
C:\ProgramData\Camera-Recovery-Automation\install.complete
```

---

## Scheduled Task

The installer registers:

```text
Camera Kiosk Recovery
```

The task:

- Runs when the configured kiosk account signs in.
- Uses Windows PowerShell 5.1.
- Runs interactively as the kiosk user.
- Runs with limited privileges.
- Starts `src\main.ps1`.
- Prevents duplicate task instances.
- Provides limited process-level restart attempts.

The application’s internal recovery loop remains responsible for browser closures and NVR-session failures.

---

## Intune Deployment

The application is packaged as a Win32 application using the Microsoft Win32 Content Prep Tool.

Recommended Intune settings:

| Setting | Value |
|---|---|
| App type | Windows Win32 app |
| Install behavior | System |
| Architecture | x64 |
| Minimum OS | Windows 11 21H2 |
| Restart behavior | No specific action |
| Detection type | File |
| Detection path | `C:\ProgramData\Camera-Recovery-Automation` |
| Detection file | `install.complete` |

Install command:

```powershell
C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\install.ps1"
```

Uninstall command:

```powershell
C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\uninstall.ps1"
```

---

## Logging

A failure log records:

- Timestamp.
- Browser-session number.
- Failure reason.

The application retains the 100 most recent failure logs and deletes older entries automatically.

Logs are intentionally preserved during uninstallation so IT can investigate failures after the runtime files have been removed.

---

## Security

This repository contains application source and non-sensitive examples only.

The following must not be committed:

- NVR usernames or passwords.
- Internal NVR URLs.
- Production `settings.json`.
- Portable runtime payloads.
- Installed dependencies.
- Generated `.intunewin` packages.
- Application failure logs.
- Organization-specific security or deployment data.

Production credentials should be maintained in an approved organizational password manager and added only to the controlled deployment payload.

The kiosk account receives modify permission only on the logs directory. The application itself runs as the limited interactive kiosk user.

---

## Out of Scope

The application does not create or manage:

- The Windows local kiosk account.
- Windows Assigned Access configuration.
- Windows automatic sign-in.
- Intune security-group membership.
- Intune policy assignment.
- NVR users, permissions, or configuration.
- Credential creation or rotation.
- Network access to the NVR.
- Enterprise monitoring or automatic ticket creation.

These responsibilities belong to the surrounding device-management and operational environment.

---

## Validation

The following behaviors have been validated:

- Intune installation as SYSTEM.
- Installation detection through `install.complete`.
- Scheduled launch after kiosk sign-in.
- Bundled Node.js execution.
- Authenticated Edge startup.
- Fullscreen browser presentation.
- Recovery after Edge is forcibly closed.
- Recovery when the monitored video element is unavailable.
- Managed Intune uninstallation.
- Preservation of failure logs during uninstallation.
- Intune package replacement and redeployment.

Long-duration stability testing remains ongoing.

---

## Version History

### v0.1 — Project Foundation

Established the project structure, entry point, modules, and initial documentation.

### v0.2 — Configuration Foundation

Added JSON configuration loading, parsing, validation, and startup error handling.

### v0.3 — Browser Authentication

Added Playwright integration, Microsoft Edge automation, authenticated browser contexts, and NVR navigation.

### v0.4 — Session Monitoring

Added video-health monitoring, failure logging, retention, browser cleanup, and continuous session recovery.

### v0.5 — Production Readiness

Added the portable runtime design, deployment payload, installation and uninstallation scripts, permanent application storage, permissions, and detection marker.

### v0.6 — Enterprise Deployment

Added Scheduled Task startup and validated the application as an Intune Win32 deployment on a Windows 11 kiosk.

### v0.6.1 — Runtime Recovery

Improved recovery after browser termination and separated browser-session recovery from Scheduled Task process recovery.

### v0.6.2 — Fullscreen Deployment

Added reliable fullscreen Edge control through the Chromium DevTools Protocol and validated the managed Intune update lifecycle.

