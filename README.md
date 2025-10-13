# contxtify

`contxtify` is a lightweight Bash utility that recursively combines all regular files in a directory tree into a single text file. It is ideal for generating plain-text snapshots of entire projects for AI analysis, code reviews, or archival.

Each file is prefixed with a header like `# path: <root>/<relative/path>` before its contents, preserving full context and structure.

---

## 🚀 Installation

Install directly (auto-selects `/usr/local/bin` or `~/.local/bin`):

```bash
curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```

To install to a custom directory:

```bash
PREFIX=/custom/path curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```
If you set a custom PREFIX, the installer will automatically create a bin directory under it if one doesn’t exist.

Verify installation:

```bash
contxtify -h
```

---

## 📦 Drop‑in Script (Root Recommended)

If you prefer to keep `contxtify` as a lightweight, project-local tool, just drop the script itself into your repo’s **root directory** — no install needed.

Add the script directly:

```bash
curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/contxtify -o contxtify
chmod +x contxtify
git add contxtify
git commit -m "Add contxtify"
```

Run it locally from your project root:

```bash
./contxtify -r . -o combined.txt
```

This approach keeps your repository self-contained and works anywhere without requiring installation.

---

## Features

* **Recursive aggregation** — walks the entire directory tree.
* **Context headers** — adds each file’s relative path before its contents.
* **Cross-platform** — works on macOS and Linux (GNU and BSD utils).
* **Hidden file toggle** — skips dotfiles unless `--all` is passed.
* **Safe writes** — uses a temporary file to prevent corruption.
* **Self-aware** — automatically excludes itself, its output, and temp files.

---

## Usage

```bash
contxtify [-r ROOT] [-o OUT] [-a] [-h]
```

| Flag | Long Form         | Description                                         |
| ---- | ----------------- | --------------------------------------------------- |
| `-r` | `--root <dir>`    | Root directory to scan (default: current directory) |
| `-o` | `--output <file>` | Output file name (default: `combined.txt`)          |
| `-a` | `--all`           | Include hidden files and directories                |
| `-h` | `--help`          | Show help and exit                                  |

---

## Examples

Combine everything in the current directory:

```bash
contxtify
```

Combine a specific project and name the output:

```bash
contxtify -r /path/to/project -o merged.txt
```

Include hidden files:

```bash
contxtify --all
```

---

## Output File Format

```
# path: myproject/src/main.py
<contents of main.py>

# path: myproject/README.md
<contents of README.md>
```

---

## Exclusions

`contxtify` automatically skips:

* The script file itself
* The output file
* Temporary working files

---

## 💡 Common Use Cases

* Exporting codebases for LLM or AI model ingestion
* Generating plain-text project archives for documentation or audit
* Sharing complex directory structures as unified readable text

---

## 🛠 Compatibility

* **Tested on:** macOS, Ubuntu, Debian
* **Dependencies:** `bash`, `find`, `realpath`, `mktemp`, `sed`, `cat`

---

## Uninstall

```bash
rm -f /usr/local/bin/contxtify ~/.local/bin/contxtify
```

---

## 🧾 License

Licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

You may use, modify, and distribute this software under the same license terms.

Copyright (C) 2025 Robert A. Moore III
