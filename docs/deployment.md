# Deployment

## Requirements

* Windows with PowerShell.
* Project files copied to the target machine.

## Configuration

Create the following file before running the application:

`config/settings.json`

Example:

```json
{
    "url": "https://google.com",
    "username": "your-username",
    "password": "your-password",
    "ignoreHttpsErrors": true,
    "headless": false,
    "startMaximized": true,
    "viewportMode": "host",
    "monitorIntervalSeconds": 5
}
```

## Running

Run the application from the project root:

```powershell
.\src\main.ps1
```
