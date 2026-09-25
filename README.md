# win-debloater

A lightweight, non-destructive Batch script to remove telemetry, disable tracking services, uninstall pre-installed Windows bloatware, and optimize Explorer settings on Windows 10 and 11.

![Platform](https://img.shields.io/badge/platform-Windows_10_%7C_11-blue)
![Language](https://img.shields.io/badge/script-Batch_%2F_PowerShell-green)
![License](https://img.shields.io/badge/license-MIT-brightgreen)

---

## Key Features

* **Telemetry Neutralization**: Stops and disables diagnostic services (`DiagTrack`, `dmwappushservice`, `WerSvc`) and privacy-invading scheduled tasks.
* **AppX Bloatware Removal**: Silently uninstalls pre-installed UWP packages (Cortana, Bing Apps, Xbox Overlay, Solitaire, Skype, etc.).
* **Registry Hardening**: Configures group policy registry entries to block telemetry data collection and Cortana background activity.
* **Explorer Enhancements**: Automatically unhides file extensions and hidden files for a cleaner developer workflow.
* **Safety & Revertibility**: Includes built-in options to create a System Restore Point before execution and a revert module to restore default Windows services.

---

## Included Debloat Targets

### 1. Disabled Services & Tasks
* `DiagTrack` (Connected User Experiences and Telemetry)
* `dmwappushservice` (WAP Push Message Routing Service)
* `WerSvc` (Windows Error Reporting Service)
* `MapsBroker` (Downloaded Maps Manager)
* Scheduled tasks under `\Microsoft\Windows\Application Experience\` & `Customer Experience Improvement Program\`

### 2. Removed AppX Packages
* `Microsoft.BingNews` / `Microsoft.BingWeather`
* `Microsoft.MicrosoftSolitaireCollection`
* `Microsoft.People` / `Microsoft.YourPhone`
* `Microsoft.XboxApp` / `Microsoft.XboxGamingOverlay`
* `Microsoft.ZuneMusic` / `Microsoft.ZuneVideo`

---

## Quick Start

1. Download or clone this repository:
   ```cmd
   git clone https://github.com/EclipzB3/win-debloater.git
   cd win-debloater
   ```
2. Right-click `win_debloater.bat` and select **Run as Administrator**.
3. Choose option `[5]` to create a System Restore Point (recommended), then select `[1]` for a Full Debloat or run individual modules.

---

## License

Distributed under the [MIT License](LICENSE).
