# Camera Kiosk Recovery

## Purpose

Automatically launch a browser, establish an authenticated NVR session, and restore that session after a reboot, browser crash, session timeout, or unexpected interruption without requiring user interaction.

## Goals

- Automatically authenticate to the NVR web interface.
- Restore authentication when the session is interrupted or expires.
- Reduce manual intervention.
- Log recovery attempts and failures.

## Responsibilities

The application is responsible for:

- Loading and validating application configuration.
- Launching and configuring the browser.
- Navigating to the configured NVR.
- Establishing an authenticated session.
- Monitoring session health.
- Restoring authenticated sessions automatically.
- Logging significant events and recovery attempts.

## Out of Scope

The following are managed outside of this application:

- Windows kiosk configuration.
- Windows auto-logon configuration.
- Automatic application launch after user sign-in (Scheduled Task, Startup folder, or Intune deployment).
- Intune configuration and deployment.
- NVR configuration.

---

# Project Roadmap

## ✅ Version 0.1 — Project Foundation

Completed:

- Project structure.
- Module organization.
- Entry point.
- Initial documentation.

---

## ✅ Version 0.2 — Configuration Foundation

Completed:

- Configuration loading.
- JSON parsing.
- Configuration validation.
- Startup error handling.
- Separation of responsibilities through modular functions.

---

## ✅ Version 0.3 — Browser Authentication

Completed:

- Browser automation framework.
- PowerShell → Node.js communication.
- Playwright integration.
- Microsoft Edge launch through Playwright.
- Browser context creation.
- Configurable HTTPS handling.
- Configurable viewport support.
- Navigation to the configured NVR URL.
- Automated username/password authentication.
- Authenticated browser session creation.

---

## ✅ Version 0.4 — Session Monitoring

Completed:

- Continuous session monitoring.
- Video element health detection.
- Automatic session restart when video is unavailable.
- Browser lifecycle management.
- Automatic browser cleanup.
- Continuous recovery loop.
- Application lifecycle logging.
- Failure log generation.
- Automatic failure log retention (100 most recent logs).

---

## ⏳ Version 0.5 — Production Readiness

Planned:

- Executable packaging.
- Deployment documentation.
- Troubleshooting guidance.
- Long-duration stability testing.
- Operational validation.

---

## ⏳ Version 0.6 — Enterprise Deployment

Planned:

- Scheduled Task integration.
- Intune deployment validation.
- Windows kiosk testing.
- Multi-device deployment guidance.

---

# Current Status

**Current Version:** **v0.4**

The application can currently:

- Load and validate configuration.
- Launch Microsoft Edge through Playwright.
- Navigate to the configured NVR.
- Authenticate using configured credentials.
- Monitor the authenticated session.
- Detect loss of the video feed.
- Automatically restart the browser session.
- Log significant lifecycle events.
- Generate and retain failure logs automatically.

The next development milestone is packaging, deployment, and production validation.