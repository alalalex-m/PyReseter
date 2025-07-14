# PyReseter

> [中文版](README_CN.md) | [English](README.md)

Python environment cleanup tool for macOS.

## What it does

PyReseter cleans up Python-related cache files and packages to free disk space and resolve environment conflicts.

**Two modes available:**
- **Cache cleanup** - Removes cache files only, keeps installed packages
- **Full reset** - Removes user-installed packages + cache files (with backup)

## Quick start

```bash
# Download and run
curl -O https://raw.githubusercontent.com/your-username/pyreseter/main/pyreseter.sh
chmod +x pyreseter.sh
./pyreseter.sh
```

## Usage

### Interactive mode (recommended)
```bash
./pyreseter.sh
```

### Command line options
```bash
./pyreseter.sh -c          # Cache cleanup only
./pyreseter.sh -f          # Full reset (packages + cache)
./pyreseter.sh -p          # Preview mode (safe)
./pyreseter.sh -h          # Help
```

## What gets cleaned

| Type | Content |
|------|---------|
| pip cache | `~/Library/Caches/pip` |
| Poetry cache | `~/Library/Caches/pypoetry` |
| Conda cache | Package cache + temp files |
| Bytecode | `__pycache__`, `.pyc`, `.pyo` files |
| Test cache | pytest, coverage, htmlcov |
| Jupyter | Checkpoints, signatures |
| Dev tools | mypy, pylint, tox cache |

## Safety features

- **Smart protection** - Never removes system packages (pip, setuptools, wheel)
- **Automatic backup** - Package lists saved to `~/.python_reset_backup/`
- **Preview mode** - See what will be cleaned before running
- **Recovery** - Restore packages with one command

## Recovery

Full reset automatically backs up your packages:

```bash
# View backups
ls ~/.python_reset_backup/

# Restore packages
pip install -r ~/.python_reset_backup/20241201_221500/pip_packages.txt
```

## Requirements

- macOS 10.14+
- Bash or Zsh
- Python (any version)

## Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help |
| `-v, --version` | Show version |
| `-p, --preview` | Preview only |
| `-c, --cache-only` | Cache cleanup mode |
| `-f, --full-reset` | Full reset mode |
| `-q, --quiet` | Quiet mode |
| `--no-backup` | Skip backup (full reset only) |

## Example results

Typical space savings:
- pip cache: 500MB - 2GB+
- Package files: Varies by usage
- Bytecode files: 10-100MB
- Other cache: 50-200MB

## Troubleshooting

**Permission denied:**
```bash
chmod +x pyreseter.sh
```

**Can't clean some files:**
Normal - files may be in use or protected.

**Python broken after reset:**
```bash
pip install --upgrade pip setuptools wheel
```

## License

MIT License - see [LICENSE](LICENSE) file.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Issues and suggestions welcome. 