<h1 align="center"> contxtify </h1>

`contxtify` is a lightweight shell utility that turns an entire folder into a single text file. It collects the contents of every file in the directory and its subfolders, adds each file’s path as a header, and combines everything into one `.txt` file.

The result is an easy way to turn a project or repository into context for AI, or to save a snapshot of a folder’s contents.

---

<h2 align="center"> 🚀 Installation </h2>

Install directly (auto-selects `/usr/local/bin` or `~/.local/bin`):

```bash
curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```

Choose an exact install directory by setting `TARGET_DIR` before running the installer:

```bash
TARGET_DIR=/usr/local/scripts curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```

Verify installation:

```bash
contxtify -h
```

---

<h2 align="center"> 📦 Drop‑in Script (Root Recommended)</h2>

If you prefer to keep `contxtify` as a lightweight, project-local tool, just drop the script itself into your repo’s **root directory** — no install needed.

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

## 🧩 Features

* **Recursive aggregation** — walks the entire directory tree.
* **Context headers** — adds each file’s relative path before its contents.
* **Cross-platform** — works on macOS and Linux (GNU and BSD utils).
* **Hidden file toggle** — skips dotfiles unless `--all` is passed.
* **Safe writes** — uses a temporary file to prevent corruption.
* **Self-aware** — automatically excludes itself, its output, and temp files.

---

## ⚙️ Usage

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

## 📘 Examples

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

## 🧠 Output Format

```
# path: myproject/src/main.py
<contents of main.py>

# path: myproject/README.md
<contents of README.md>
```

---

## 🔒 Exclusions

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

<h2 align="center"> Uninstall </h2>

```bash
rm -f /usr/local/bin/contxtify ~/.local/bin/contxtify
```

---

## 🧾 License

Licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

You may use, modify, and distribute this software under the same license terms.

Copyright (C) 2025 Robert A. Moore III
