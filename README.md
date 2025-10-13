# contxtify

`contxtify` is a portable Bash utility that recursively combines the contents of all regular files under a root directory into a single text file — ideal for generating AI-readable snapshots of codebases, configs, or documentation.

Each file is prefixed with a header showing its relative path, preserving file context while enabling easy search and parsing.

---

## 🧩 Features

* **Recursive aggregation** — Walks the entire directory tree.
* **Context headers** — Adds `# path: <root>/<relative/path>` before each file.
* **Cross-platform** — Works on Linux and macOS (GNU or BSD utils).
* **Hidden file control** — Skips dotfiles and hidden directories unless `--all` is used.
* **Safe writing** — Uses a temporary file for atomic writes.
* **Self-exclusion** — Automatically omits itself, its temp file, and the output file.

---

## ⚙️ Usage

```bash
./contxtify [-r ROOT] [-o OUT] [-a] [-h]
```

### Options

| Flag | Long Form         | Description                                                    |
| ---- | ----------------- | -------------------------------------------------------------- |
| `-r` | `--root <dir>`    | Root directory to scan. Default: current directory             |
| `-o` | `--output <file>` | Output file name (created under ROOT). Default: `combined.txt` |
| `-a` | `--all`           | Include hidden files and directories                           |
| `-h` | `--help`          | Show help and exit                                             |

---

## 📘 Examples

Combine everything in the current directory:

```bash
./contxtify
```

Specify a project root and custom output file:

```bash
./contxtify -r /path/to/project -o merged.txt
```

Include hidden files and directories:

```bash
./contxtify --all
```

---

## 🧠 Output Format

Each file appears in the merged output like this:

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
* Its temporary working file

---

## 💡 Common Use Cases

* Preparing codebases for AI model ingestion or context packaging
* Generating unified text archives for documentation or audits
* Creating portable, human-readable project dumps

---

## 🛠 Compatibility

* **Tested on:** macOS, Ubuntu, Debian
* **Dependencies:** `bash`, `find`, `realpath`, `mktemp`, `sed`, `cat`

---

## 🚀 Installation

Clone the repository and make it executable:

```bash
git clone https://github.com/<your-username>/contxtify.git
cd contxtify
chmod +x contxtify
```

Run directly from anywhere:

```bash
./contxtify -r ~/myproject
```

Or copy to your PATH:

```bash
sudo cp contxtify /usr/local/bin/
```

---

## License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

You may freely use, modify, and distribute this software under the same license terms.

Copyright (C) 2025 Robert A. Moore III
