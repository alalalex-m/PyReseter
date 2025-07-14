# PyReseter

> [中文版](README_CN.md) | [English](README.md)

macOS Python 环境清理工具。

## 功能

PyReseter 可以清理 Python 相关的缓存文件和包，释放磁盘空间，解决环境冲突。

**两种模式：**
- **缓存清理** - 只删除缓存文件，保留已安装的包
- **完全重置** - 删除用户安装的包 + 缓存文件（有备份）

## 快速开始

```bash
# 下载并运行
curl -O https://raw.githubusercontent.com/your-username/pyreseter/main/pyreseter.sh
chmod +x pyreseter.sh
./pyreseter.sh
```

## 使用方法

### 交互式模式（推荐）
```bash
./pyreseter.sh
```

### 命令行选项
```bash
./pyreseter.sh -c          # 只清理缓存
./pyreseter.sh -f          # 完全重置（包+缓存）
./pyreseter.sh -p          # 预览模式（安全）
./pyreseter.sh -h          # 帮助
```

## 清理内容

| 类型 | 内容 |
|------|------|
| pip缓存 | `~/Library/Caches/pip` |
| Poetry缓存 | `~/Library/Caches/pypoetry` |
| Conda缓存 | 包缓存 + 临时文件 |
| 字节码 | `__pycache__`, `.pyc`, `.pyo` 文件 |
| 测试缓存 | pytest, coverage, htmlcov |
| Jupyter | 检查点, 签名文件 |
| 开发工具 | mypy, pylint, tox 缓存 |

## 安全特性

- **智能保护** - 不会删除系统包（pip, setuptools, wheel）
- **自动备份** - 包列表保存到 `~/.python_reset_backup/`
- **预览模式** - 执行前查看将要清理的内容
- **恢复功能** - 一个命令恢复删除的包

## 恢复

完全重置会自动备份包列表：

```bash
# 查看备份
ls ~/.python_reset_backup/

# 恢复包
pip install -r ~/.python_reset_backup/20241201_221500/pip_packages.txt
```

## 系统要求

- macOS 10.14+
- Bash 或 Zsh
- Python（任何版本）

## 选项说明

| 选项 | 说明 |
|------|------|
| `-h, --help` | 显示帮助 |
| `-v, --version` | 显示版本 |
| `-p, --preview` | 只预览 |
| `-c, --cache-only` | 缓存清理模式 |
| `-f, --full-reset` | 完全重置模式 |
| `-q, --quiet` | 静默模式 |
| `--no-backup` | 跳过备份（仅完全重置） |

## 预期效果

典型的空间释放：
- pip缓存：500MB - 2GB+
- 包文件：因使用情况而异
- 字节码文件：10-100MB
- 其他缓存：50-200MB

## 故障排除

**权限不足：**
```bash
chmod +x pyreseter.sh
```

**无法清理某些文件：**
正常现象 - 文件可能正在使用或受保护。

**重置后 Python 异常：**
```bash
pip install --upgrade pip setuptools wheel
```

## 许可证

MIT 许可证 - 查看 [LICENSE](LICENSE) 文件。

## 贡献

1. Fork 仓库
2. 创建功能分支
3. 提交更改
4. 发起 Pull Request

欢迎提交问题和建议。 