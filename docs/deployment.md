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
    "username": "your_username",
    "password": "your_password"
}
```

## Running

Run the application from the project root:

```powershell
.\src\main.ps1
```
