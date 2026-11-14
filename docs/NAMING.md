# Naming convention

## Product code format

```
PRJ-NOD-VVR
 │   │   ││
 │   │   │└─ Revision letter (A, B, C...)
 │   │   └── Version number (01, 02, 03...)
 │   └────── Node code (3 letters)
 └────────── Product line (3 letters)
```

## Product line

| Code | Name | Description |
|------|------|-------------|
| PRJ  | _your product line_ | _change this_ |

## Node codes

| Code | Node | Description |
|------|------|-------------|
| ??? | _node 1_ | _describe this node_ |
| ??? | _node 2_ | _describe this node_ |
| APP | App | Mobile / desktop application (software only) |
| CLD | Cloud | Cloud backend (software only) |

## Version numbers

| Version | Meaning |
|---------|---------|
| 01      | First generation |
| 02      | Second generation |
| 03+     | Subsequent generations |

## Revision letters

| Letter | Meaning |
|--------|---------|
| A      | First PCB spin / first release |
| B      | Second spin (bug fixes, layout changes) |
| C+     | Subsequent spins |

Increments when: PCB layout changes, schematic changes affecting BOM, major firmware architecture change.

Does NOT increment for: firmware bug fixes, documentation updates, software-only changes.

## Folder structure

Folder name drops the revision letter. Revision lives in `hw/rev-x/` and `config.h`.

```
prj-nod-01/
├── hw/
│   ├── rev-a/              # Per-revision: schematic/, pcb/, bom/, 3d/
│   ├── rev-b/              # Next revision (when PCB changes)
│   └── datasheets/         # Shared across revisions
├── fw/                     # Shared firmware (HW_REVISION in config.h)
├── docs/
├── tools/
├── .gitignore
└── README.md
```

## Where the code appears

| Location | Format | Example |
|----------|--------|---------|
| Folder name | lowercase, no rev letter | `prj-nod-01` |
| hw/ subfolder | lowercase | `hw/rev-a/` |
| HW export filename | uppercase, with rev letter | `PRJ-NOD-01A-SCH-20261115-1430.pdf` |
| PCB silkscreen | uppercase | `PRJ-NOD-01A` |
| BOM header | uppercase | `PRJ-NOD-01A` |
| Firmware log | uppercase | `=== PRJ-NOD-01A fw-v1.0.0 ===` |
| Git repo | lowercase, no rev letter | `prj-nod-01` |
| Git tag (fw) | lowercase | `prj-nod-01-fw-v1.0.0` |
| Git tag (hw fab) | lowercase | `prj-nod-01-hw-r1` |
| README title | uppercase, no rev letter | `# PRJ-NOD-01` |

## Hardware file naming

Export files from EasyEDA & KiCad follow this pattern:

```
PRJ-NOD-VVR-TYPE-YYYYMMDD-HHMM.ext
 │   │   │   │    │        └── Export time (24h)
 │   │   │   │    └─────────── Export date
 │   │   │   └──────────────── File type code
 │   │   └──────────────────── Version + revision
 │   └─────────────────────── Node code
 └──────────────────────────── Product line
```

### File type codes

| Code | Type | Extension | Description |
|------|------|-----------|-------------|
| SCH  | Schematic | `.pdf` `.json` | Circuit schematic export |
| PCB  | PCB layout | `.pdf` `.json` `.gerber.zip` | Board layout / Gerber files |
| BOM  | Bill of materials | `.csv` `.xlsx` | Component list with values and footprints |
| 3D   | 3D model | `.step` `.stl` | Board 3D export |
| ASM  | Assembly | `.pdf` | Assembly drawing (placement guide) |

### Examples

```
hw/rev-a/schematic/
  PRJ-NOD-01A-SCH-20261115-1430.pdf

hw/rev-a/pcb/
  PRJ-NOD-01A-PCB-20261115-1430.gerber.zip

hw/rev-a/bom/
  PRJ-NOD-01A-BOM-20261115-1430.csv

hw/rev-a/3d/
  PRJ-NOD-01A-3D-20261115-1430.step

hw/datasheets/                     # shared across revisions
  COMPONENT-NAME.pdf
```

### Rules

- Product code in filename is always **UPPERCASE** and includes the revision letter
- Date-time is the export moment, not the design date — re-export = new timestamp
- Datasheets keep the manufacturer's original filename (no renaming)
- Gerber ZIP contains the individual Gerber files (no renaming inside the ZIP)

## Git branching strategy

| Concept | Mechanism |
|---------|-----------|
| **Version** (01→02) | New folder (`prj-nod-02/`) |
| **Revision** (A→B) | `hw/rev-b/` subfolder + `HW_REVISION` in `config.h` |
| **Variant** (full/lite/pro) | Branch (`variant/lite`) |
| **Firmware release** | Tag (`prj-nod-01-fw-v1.0.0`) |
| **Hardware fab** | Tag (`prj-nod-01-hw-r1`) |
| **Experiment** | Branch (delete if it fails) |
| **Hotfix on old release** | Branch from tag (`hotfix/v1.0.1`) |
| **Daily work** | Commit on `main` |

### Variants

A variant is a different board configuration branched from `main`:

```
main              ← full version
variant/lite      ← lite (fewer peripherals)
```

Shared bug fixes flow from `main` into variants via `git merge main`.

## GitHub Releases & firmware versioning

### Git tags

```
prj-nod-01-fw-v1.0.0      # first release
prj-nod-01-fw-v1.0.1      # bug fix
prj-nod-01-fw-v1.1.0      # new feature
prj-nod-01-fw-v2.0.0      # breaking change
```

### Creating a GitHub Release

```bash
git tag -a prj-nod-01-fw-v1.0.0 -m "First firmware release"
git push origin prj-nod-01-fw-v1.0.0

gh release create prj-nod-01-fw-v1.0.0 \
  fw/build/prj-nod-01.bin \
  --title "PRJ-NOD-01 Firmware v1.0.0" \
  --notes "First stable release."
```

### Release artifacts

| File | Description |
|------|-------------|
| `prj-nod-01.bin` | Application binary (flash to 0x10000) |
| `bootloader.bin` | Bootloader (flash to 0x0) |
| `partition-table.bin` | Partition table (flash to 0x8000) |
| `flash_args.txt` | Offsets for esptool |

### Version in firmware

```c
#define PRODUCT_CODE    "PRJ-NOD-01A"
#define HW_REVISION     'A'
#define FW_VERSION      "1.0.0"
```

```c
ESP_LOGI(TAG, "=== %s fw-v%s ===", PRODUCT_CODE, FW_VERSION);
```
