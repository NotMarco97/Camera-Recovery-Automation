# Camera Kiosk Recovery

## Purpose

Automatically restore and maintain an authenticated NVR browser session after a reboot, browser crash, session timeout, or unexpected interruption without requiring user interaction.

## Goals

* Automatically authenticate to the NVR web interface.
* Restore authentication when the session is interrupted or expires.
* Reduce manual intervention.
* Log recovery attempts and failures.

## Responsibilities

The application is responsible for:

* Loading and validating application configuration.
* Detecting when the NVR session is no longer authenticated.
* Restoring authentication automatically.
* Monitoring the authenticated session for interruptions.
* Logging significant events and recovery attempts.

## Out of Scope

The following are managed outside of this application:

* Windows kiosk configuration.
* Windows auto-login.
* Microsoft Edge startup.
* Opening the NVR URL.
* Intune configuration and deployment.
* NVR system configuration.
* Certificate trust management (unless browser automation becomes the only viable fallback).

## Project Roadmap

### ✅ Version 0.1 — Project Foundation

Completed:

* Project structure.
* Module organization.
* Entry point.
* Initial documentation.

### ✅ Version 0.2 — Configuration Foundation

Completed:

* Configuration loading.
* JSON parsing.
* Configuration validation.
* Startup error handling.
* Separation of responsibilities through modular functions.

### 🚧 Version 0.3 — Authentication

Planned:

* Browser automation framework.
* Login page detection.
* Username/password entry.
* Login verification.
* Certificate handling (only if infrastructure cannot eliminate it).

### Planned Future Versions

**Version 0.4 — Session Monitoring**

* Detect logout.
* Detect session timeout.
* Refresh browser session.
* Reauthenticate automatically.

**Version 0.5 — Production Readiness**

* Logging improvements.
* Deployment documentation.
* Troubleshooting guidance.
* Operational validation.

## Current Status

**Current Version:** v0.2

The application successfully initializes, loads and validates configuration, and establishes the foundation required for browser automation and authentication in subsequent versions.
