# Contributing

## Setup

1. Install [ESP-IDF v5.3+](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/)
2. Clone this repo
3. Run `.\tools\setup.ps1 -Target <chip>` to configure the build environment

## Daily workflow

```powershell
# Edit code
.\tools\build.ps1               # build
.\tools\flash.ps1 COM3          # flash
.\tools\monitor.ps1 COM3        # check serial output
git add fw/
git commit -m "feat: add low battery warning"
```

## Commit message format

```
type: short description

types: feat, fix, hw, docs, tools, refactor
```

Examples:
- `feat: add BLE heartbeat every 30s`
- `fix: IMU wake interrupt not clearing`
- `hw: update schematic, add pull-up on SDA`
- `docs: add test plan for collision detection`
- `tools: add release script`

## Hardware changes

1. Make changes in EasyEDA & KiCad
2. Export to `hw/rev-a/` (overwrite existing files, git tracks history)
3. Use naming: `PRODUCT_CODE-TYPE-YYYYMMDD-HHMM.ext` (e.g. `VSM-HEL-03A-SCH-20261115-1430.pdf`)
4. Commit: `git commit -m "hw: added pull-up on SDA line"`
5. When sending to fab: `git tag <project>-hw-r1 -m "First fabrication"`

## Firmware release

```powershell
# Bump FW_VERSION in fw/main/config.h first
.\tools\release.ps1 -Version 1.0.0
```

This will:
1. Build the firmware
2. Create a git tag (`<project>-fw-v1.0.0`)
3. Push the tag
4. Create a GitHub Release with `.bin` files attached

## New hardware revision

When the PCB changes enough to affect the BOM or firmware pins:

1. Create `hw/rev-b/` with new schematic, pcb, bom, 3d subfolders
2. Update `config.h`: `HW_REVISION` to `'B'`, `PRODUCT_CODE` to `"...-02B"`
3. Adjust pin assignments in `config.h` if needed
4. Commit: `git commit -m "hw: rev B, moved buzzer to GPIO5"`

## Variant boards

For a different configuration (lite, pro):

```bash
git checkout -b variant/lite main
# Remove/add components, update config.h
git commit -m "hw: lite variant, removed barometer"
```

Pull shared fixes: `git checkout variant/lite && git merge main`

## Branch summary

| Branch | Purpose |
|--------|---------|
| `main` | Active development |
| `variant/<name>` | Board variant (lite, pro) |
| `hotfix/v1.0.1` | Patch an old release |
| `hw/try-<feature>` | Hardware experiment |
