# Windows Edition Switcher

A batch script to easily switch between various editions of Windows 10 and Windows 11


## Supported Editions

* Home (Core) -> Home Single Lang, Pro, Pro Workstation, Pro Edu, Edu[+VL], Enterprise VL, ServerRdsh[+VL]
* Pro <-> Pro Workstation <-> Pro Edu <-> Edu <-> Enterprise <-> ServerRdsh <-> IoT Enterprise
* Enterprise LTSC <-> IoT Enterprise LTSC
* And more...

## Usage

[Download](https://github.com/jetfir3/Windows-Edition-Switcher/releases/latest/download/Windows-Edition-Switcher.bat) the batch script, right-click on the file and select 'Run as Administrator' to run.

## Notes

* Script lists Windows edition(s) that can be switched to.
* Upgrading from Core to Non-Core may produce an error. Ignore, close script and reboot to complete switch.
* Disabling the internet before switching editions may be needed in some situations.
* Sidegrading [RETAIL] <--> [VOLUME] may be possible despite not being listed in supported editions output.  

## Statement
* Repository does not contain any activation-related keys, only product keys for switching Windows edition
* All product keys are sourced from official Windows 11 installation media and Microsoft's [website](https://docs.microsoft.com/windows-server/get-started/kms-client-activation-keys)
* Windows, Windows 10, Windows 11 are trademarks of Microsoft Corporation
* This repo was forked from https://github.com/TerryHuangHD/Windows10-VersionSwitcher
