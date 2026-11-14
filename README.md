# Project Name

> One-line description.

> Current revision: **A** (see `fw/main/config.h`)

## Structure

```
project-name/
├── hw/                     # Hardware
│   ├── rev-a/              # Per-revision exports
│   │   ├── schematic/      # EasyEDA & KiCad exports (.json, .pdf)
│   │   ├── pcb/            # PCB layout (.json, .pdf, gerber/)
│   │   ├── bom/            # Bill of materials (.csv, .xlsx)
│   │   └── 3d/             # Enclosure, mechanical (STEP, STL)
│   └── datasheets/         # Component datasheets (shared across revisions)
│
├── fw/                     # Firmware (ESP-IDF project root)
│   ├── main/               # Application source
│   │   ├── CMakeLists.txt
│   │   ├── idf_component.yml
│   │   ├── config.h        # Product identity, pin assignments, thresholds
│   │   └── main.c
│   ├── components/         # Custom ESP-IDF components (optional)
│   ├── partitions.csv
│   ├── sdkconfig.defaults
│   └── CMakeLists.txt      # ESP-IDF project CMake
│
├── docs/                   # Documentation
│   ├── requirements/       # Requirements, specs
│   ├── design/             # Architecture, block diagrams
│   ├── test/               # Test plans, results
│   └── NAMING.md           # Naming convention reference
│
├── tools/                  # Helper scripts
│   ├── setup.ps1           # Set ESP-IDF env + target
│   ├── build.ps1           # Build firmware
│   ├── flash.ps1           # Flash to device
│   ├── monitor.ps1         # Serial monitor
│   └── release.ps1         # Tag + GitHub Release
│
├── .github/
│   └── workflows/
│       └── build.yml       # CI: auto-build on tag push
│
├── .editorconfig
├── .gitignore
├── CHANGELOG.md
└── README.md
```

## Quick start

```powershell
# First time: set up ESP-IDF environment and chip target
.\tools\setup.ps1 -Target esp32    # or esp32c6, esp32s3, etc.
```

```powershell
# Build
.\tools\build.ps1
```

```powershell
# Flash + monitor
.\tools\flash.ps1 COM3
.\tools\monitor.ps1 COM3
```

## Release

```powershell
# Build, tag, and create GitHub Release
.\tools\release.ps1 -Version 1.0.0
```

## License

MIT
