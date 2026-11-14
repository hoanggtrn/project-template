# Project Guide

Read this before making changes.

## Identity

- See `fw/main/config.h` for `PRODUCT_CODE`, `HW_REVISION`, `FW_VERSION`
- Folder name has no revision letter; revision lives in `hw/rev-x/` and `config.h`
- Naming convention: `docs/NAMING.md`

## Build

```powershell
.\tools\setup.ps1 -Target esp32     # first time only, set chip target
.\tools\build.ps1                    # build firmware
.\tools\flash.ps1 COM3              # flash
.\tools\monitor.ps1 COM3            # serial monitor
```

Requires ESP-IDF v5.3+. IDF path: `G:\esp\esp-idf`.

## Project structure

```
hw/rev-a/           schematic, pcb, bom, 3d (per revision)
hw/datasheets/      component datasheets (shared)
fw/                 ESP-IDF project (main/, components/, sdkconfig.defaults)
docs/               requirements, design, test
tools/              PowerShell helper scripts
```

## Git workflow

- Branch: `main` for development
- Commit messages: imperative, lowercase, concise (`fix: IMU wake not clearing`)
- Hardware exports: overwrite same file, commit with description of change
- Firmware release: `.\tools\release.ps1 -Version 1.0.0` (builds, tags, creates GitHub Release)
- Tag format: `<project-name>-fw-v1.0.0` (read from `fw/CMakeLists.txt`)
- Hardware fab tag: `<project-name>-hw-r1`
- Variant boards: branch `variant/<name>`, merge fixes from main
- Hotfix on old release: branch `hotfix/v1.0.1` from the release tag

## Hardware file naming

```
PRODUCT_CODE-TYPE-YYYYMMDD-HHMM.ext
```

Types: SCH, PCB, BOM, 3D, ASM. Always UPPERCASE. See `docs/NAMING.md`.

## Rules

- `config.h` is the single source of truth for pins, thresholds, and product identity
- Hardware truth is the EasyEDA & KiCad schematic — pin assignments in code must match it
- All code in English
- No unused code, no commented-out code
- Bump `FW_VERSION` in `config.h` before tagging a release
