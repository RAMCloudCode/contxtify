# Contxtify

`contxtify` is a lightweight Bash utility that flattens the text files in a directory tree into one context file or stdout stream. Each included file is preceded by a root-inclusive path, making the result suitable for AI context, review, documentation, and plain-text project snapshots.

It runs on macOS and Linux and automatically skips binary files.

## Installation

Install directly. The installer uses `/usr/local/bin` when writable and otherwise falls back to `~/.local/bin`:

```bash
curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```

Choose an exact installation directory with `TARGET_DIR`:

```bash
TARGET_DIR=/usr/local/scripts curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/install.sh | sh
```

Verify the installation:

```bash
contxtify --help
```

## Project-local script

You can also keep the script directly in a repository:

```bash
curl -fsSL https://raw.githubusercontent.com/RAMCloudCode/contxtify/main/contxtify -o contxtify
chmod +x contxtify
```

Run it from the project directory:

```bash
./contxtify
```

The script excludes itself when it is located inside the scanned directory.

## Usage

```text
contxtify [options]
```

| Flag | Long form | Description |
| --- | --- | --- |
| `-d DIR` | `--directory DIR` | Directory to scan recursively. Defaults to the current directory. |
| `-r ROOT` | `--root ROOT` | Root used to calculate paths in file headers. Defaults to the scanned directory. |
| `-o FILE` | `--output FILE` | Output file. A relative path is resolved from the current working directory. Defaults to `contxt-<directory-name>.txt`. |
| `-o -` | `--output -` | Write flattened content to stdout and do not create an output file. |
| `-i PATTERN` | `--ignore PATTERN` | Ignore a relative path or glob-style pattern. Repeat the option to add rules. |
| `-g FILE` | `--gitignore FILE` | Use a specific ignore file instead of the automatic `<root>/.gitignore`. |
| `-a` | `--all` | Include hidden files and directories. |
| `-h` | `--help` | Show built-in help. |

With no options, `contxtify` scans the current directory, uses that same directory as the path root, and writes `contxt-<current-directory-name>.txt` inside it.

## Directory and root behavior

`--directory` controls only what is scanned. `--root` only controls how paths are calculated for the output headers. Each header includes the root directory itself, followed by the file's path beneath it.

The scanned directory must be the root itself or a directory beneath it. A directory outside the root is rejected because it cannot produce an unambiguous root-relative path.

For example:

```bash
contxtify --root /project --directory /project/src
```

Only `/project/src` is scanned, while each header starts with the root directory name, `project`:

```text
<<< FILE: project/src/package/module.py >>>

<contents of module.py>
```

If `--root` is omitted, it defaults to `--directory`. If both are omitted, both default to the current directory.

## Output

The default output name uses the basename of the scanned directory, but the file is created in the current working directory. For example, when invoked from `~/Desktop`:

```bash
cd ~/Desktop
contxtify --directory ~/projects/repoA
```

This writes:

```text
~/Desktop/contxt-repoA.txt
```

Use `--output` to choose another name. Relative output paths are resolved from the directory where `contxtify` was invoked, independently of `--directory`. Absolute output paths continue to work normally.

Use `-o -` to send only the flattened content to stdout:

```bash
contxtify -o - | pbcopy
contxtify -o - > project-context.txt
contxtify -d src -r . -o - | less
```

The normal `Wrote ...` status message is not emitted in stdout mode, so it cannot pollute a pipe or redirected file.

## Output format

Every text file begins with this marker:

```text
<<< FILE: root-directory/path/to/file >>>

<file contents>
```

There is exactly one blank line between the `<<< FILE: ... >>>` marker and the beginning of the file contents. Paths include the basename of `--root` and then the path beneath that root. When `--root` is `/`, the header retains the leading `/`.

## Ignore behavior

Explicit ignore rules are repeatable and additive:

```bash
contxtify -i build -i '*.log' -i generated/cache
```

Rules without a slash, such as `build` or `*.log`, match names at any depth. Relative paths containing a slash, such as `generated/cache`, are resolved from the scanned directory. Quote glob patterns so the shell does not expand them before `contxtify` receives them.

Matching directories are pruned by `find`; their contents are never traversed or scanned.

### Automatic `.gitignore`

If `<root>/.gitignore` exists, `contxtify` automatically loads it as another source of ignore rules. Common `.gitignore` behavior is supported, including comments, basename and path globs, directory-only rules, root-anchored rules, and negated re-inclusion rules.

Supply a different file with `--gitignore`:

```bash
contxtify --gitignore config/context.gitignore
```

Patterns in either the automatic or explicitly supplied ignore file are interpreted relative to `--root`.

The explicit file replaces the automatically discovered `<root>/.gitignore`. Rules from `-i` and `--ignore` remain additive.

### Other automatic exclusions

Independently of ignore rules, `contxtify` skips:

- Binary files, detected with a lightweight NUL-byte-oriented text check
- The generated output file
- Its temporary assembly file
- The `contxtify` script itself when it is inside the scan
- Hidden files and directories, unless `--all` is used

Binary exclusion is always enabled. This prevents images, compiled artifacts, archives, and other non-text formats from being copied into the flattened output.

## Examples

Scan the current directory with all defaults:

```bash
contxtify
```

Scan a repository and choose the output name:

```bash
contxtify -d /path/to/project -o merged.txt
```

Scan only a source subtree while retaining project-root-inclusive headers:

```bash
contxtify -r /path/to/project -d /path/to/project/src
```

Include hidden files while keeping ignore and binary exclusions active:

```bash
contxtify --all
```

Combine explicit rules with the root `.gitignore`:

```bash
contxtify -i build -i '*.log' -i generated/cache
```

Stream the result without creating a file:

```bash
contxtify -o - | pbcopy
```

## Compatibility

- Supported platforms: macOS and Linux
- Required commands: `bash`, `find`, `mktemp`, `grep`, `cat`, `dirname`, `basename`, `mv`, and `rm`
- No language runtime, package manager, or Git installation is required

## Uninstall

Remove the installed executable from whichever installation location was used, for example:

```bash
rm -f /usr/local/bin/contxtify
```

or:

```bash
rm -f ~/.local/bin/contxtify
```

## License

Licensed under the GNU General Public License v3.0 (GPL-3.0).

You may use, modify, and distribute this software under the same license terms.

Copyright (C) 2025 Robert A. Moore III
