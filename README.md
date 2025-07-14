# PyReseter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Shell: Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Version: 3.0](https://img.shields.io/badge/Version-3.0-red.svg)](https://github.com/your-username/pyreseter/releases)

🧹 **PyReseter** 是一个专为 macOS 设计的 Python 环境重置工具，可以安全、彻底地清理 Python 相关的缓存文件和用户安装的包，帮助释放磁盘空间并解决环境冲突问题。

## ✨ 功能特性

### 🎯 双模式清理
- **🧹 温和清理模式** - 仅清理缓存文件，保留所有已安装的包
- **💥 完全重置模式** - 删除用户安装的包 + 清理所有缓存文件

### 🛡️ 安全保证
- **智能保护** - 自动保护系统必需包（pip、setuptools、wheel等）
- **自动备份** - 完全重置前自动备份包列表，支持一键恢复
- **预览模式** - 所有操作都有安全预览版本，先看后清理
- **详细日志** - 彩色输出，清楚显示每个操作的结果

### 🗑️ 全面清理
| 清理类型 | 内容 |
|---------|------|
| **pip缓存** | `~/Library/Caches/pip` + pip/pip3 缓存命令 |
| **Poetry缓存** | `~/Library/Caches/pypoetry` + poetry 缓存命令 |
| **Conda缓存** | Anaconda/Miniconda 包缓存 + conda 清理命令 |
| **字节码文件** | `__pycache__` 目录、`.pyc`/`.pyo` 文件 |
| **测试缓存** | pytest、coverage、htmlcov 等测试工具缓存 |
| **Jupyter缓存** | notebook 检查点、签名数据库、历史记录 |
| **虚拟环境缓存** | virtualenv、pipenv 相关缓存 |
| **开发工具缓存** | mypy、pylint、bandit、tox 等工具缓存 |
| **matplotlib缓存** | 字体和配置缓存 |

### 🚀 简便易用
- **🖥️ 交互式菜单** - 美观的图形化菜单界面（默认模式）
- **⚡ 命令行支持** - 丰富的命令行参数，支持脚本自动化
- **📱 一键运行** - 下载即用，无需额外依赖

## 📦 安装

### 方法一：Git 克隆（推荐）
```bash
git clone https://github.com/your-username/pyreseter.git
cd pyreseter
chmod +x pyreseter.sh
```

### 方法二：直接下载
```bash
curl -O https://raw.githubusercontent.com/your-username/pyreseter/main/pyreseter.sh
chmod +x pyreseter.sh
```

## 🎮 使用方法

### 🖥️ 交互式模式（推荐新手）
```bash
./pyreseter.sh
```

这将启动美观的交互式菜单：

```
    ____        ____                     __            
   / __ \__  __/ __ \___  ________  ____/ /____  _____
  / /_/ / / / / /_/ / _ \/ ___/ _ \/ __  / _ \/ ___/
 / ____/ /_/ / _, _/  __(__  )  __/ /_/ /  __/ /    
/_/    \__, /_/ |_|\___/____/\___/\__,_/\___/_/     
      /____/                                        

Python Environment Reset Tool for macOS
Version 3.0

=== 选择清理模式 ===

1) 🔍 预览缓存清理（安全查看）
2) 🧹 执行缓存清理（温和模式）
3) 🔍 预览完全重置（安全查看）
4) 💥 执行完全重置（删除包+缓存）
5) ❓ 帮助信息
6) 🚪 退出

请选择 [1-6]:
```

### ⚡ 命令行模式（推荐高级用户）

#### 预览模式（安全查看）
```bash
# 预览缓存清理
./pyreseter.sh --preview

# 预览完全重置
./pyreseter.sh --preview --full-reset
```

#### 执行清理
```bash
# 温和清理（仅缓存）
./pyreseter.sh --cache-only

# 完全重置（包+缓存）
./pyreseter.sh --full-reset

# 完全重置且不备份包列表
./pyreseter.sh --full-reset --no-backup

# 静默模式执行
./pyreseter.sh --cache-only --quiet
```

#### 其他选项
```bash
# 显示帮助
./pyreseter.sh --help

# 显示版本信息
./pyreseter.sh --version
```

## 📋 命令行参数

| 参数 | 简写 | 描述 |
|------|------|------|
| `--help` | `-h` | 显示帮助信息 |
| `--version` | `-v` | 显示版本信息 |
| `--preview` | `-p` | 只预览，不执行清理 |
| `--cache-only` | `-c` | 只清理缓存（温和模式） |
| `--full-reset` | `-f` | 完全重置（删除包+缓存） |
| `--interactive` | `-i` | 交互式模式（默认） |
| `--quiet` | `-q` | 静默模式，减少输出 |
| `--no-backup` | | 不备份包列表（仅完全重置模式） |

## 📊 使用示例

### 场景一：日常维护（推荐）
释放磁盘空间，但保留所有已安装的包：
```bash
./pyreseter.sh -c
```

### 场景二：环境修复
Python环境出现问题，需要重建：
```bash
# 先预览会删除什么
./pyreseter.sh -p -f

# 确认后执行完全重置
./pyreseter.sh -f
```

### 场景三：自动化脚本
在CI/CD或自动化脚本中使用：
```bash
# 静默清理，不需要用户交互
./pyreseter.sh -c -q

# 完全重置且不备份（适用于Docker等环境）
./pyreseter.sh -f --no-backup -q
```

## 🔄 包恢复

完全重置模式会自动备份包列表到 `~/.python_reset_backup/`：

```bash
# 查看备份
ls ~/.python_reset_backup/

# 恢复包（使用最新备份）
pip install -r ~/.python_reset_backup/20241201_221500/pip_packages.txt

# 如果使用conda
conda install --file ~/.python_reset_backup/20241201_221500/conda_packages.txt
```

## 📈 预期效果

根据实际测试，PyReseter 可以为您：

- 🗑️ **释放磁盘空间**: 通常可释放 500MB - 2GB+ 的磁盘空间
- 🚀 **提升性能**: 清理过期缓存，提高包管理器响应速度  
- 🔧 **解决冲突**: 解决包版本冲突和环境污染问题
- 🧹 **环境清洁**: 移除无用的字节码和临时文件

### 真实用户反馈
```
您的系统检测结果：
✅ pip缓存: 959MB
✅ 101个用户安装的包
✅ 1个__pycache__目录，5个.pyc文件
✅ matplotlib缓存: 168KB

预计总共释放: 960MB+ 磁盘空间
```

## ⚠️ 注意事项

### 温和清理模式（安全）
- ✅ 只清理缓存文件，不影响已安装的包
- ✅ 可以随时运行，没有风险
- ✅ 建议定期使用（如每月一次）

### 完全重置模式（需谨慎）
- ⚠️ 会删除所有用户安装的Python包
- ✅ 自动备份包列表，可完全恢复
- ✅ 保护系统必需包，不会破坏Python环境
- 💡 适用于环境损坏或需要全新环境的情况

## 🔧 故障排除

### Q: 脚本运行时提示权限不足
**A**: 确保脚本有执行权限：
```bash
chmod +x pyreseter.sh
```

### Q: 某些缓存无法清理
**A**: 这是正常现象，可能因为：
- 文件正在被其他进程使用
- 权限限制
- 文件不存在

### Q: 完全重置后想恢复包
**A**: 使用自动创建的备份文件：
```bash
# 查看所有备份
ls ~/.python_reset_backup/

# 恢复最新备份的包
pip install -r ~/.python_reset_backup/$(ls -t ~/.python_reset_backup/ | head -1)/pip_packages.txt
```

### Q: 清理后Python环境异常
**A**: 
1. 重启终端
2. 检查Python版本：`python --version`
3. 重新安装必要的包：`pip install --upgrade pip setuptools wheel`

## 🛠️ 系统要求

- **操作系统**: macOS 10.14+ (Mojave 或更高版本)
- **Shell**: Bash 4.0+ 或 Zsh
- **权限**: 用户目录读写权限
- **Python**: 任何版本的Python 2.7 或 3.x（可选择性支持）

## 🤝 贡献指南

我们欢迎社区贡献！以下是参与方式：

### 🐛 报告问题
在 [Issues](https://github.com/your-username/pyreseter/issues) 页面报告问题时，请包含：
- macOS版本
- Python版本
- 详细的错误信息
- 重现步骤

### 💡 功能建议
通过 [Issues](https://github.com/your-username/pyreseter/issues) 提出新功能建议。

### 🔀 代码贡献
1. Fork 这个仓库
2. 创建功能分支：`git checkout -b feature/新功能`
3. 提交更改：`git commit -am '添加新功能'`
4. 推送分支：`git push origin feature/新功能`
5. 创建 Pull Request

### 📖 文档改进
文档改进同样重要！欢迎改进README、添加使用示例等。

## 📝 更新日志

### v3.0 (2024-12-01)
- 🎉 全新统一入口：`pyreseter.sh`
- ✨ 美观的交互式菜单界面
- 🚀 丰富的命令行参数支持
- 🛡️ 改进的安全保护机制
- 📊 更好的预览和统计功能

### v2.0 (2024-11-30)
- 💥 新增完全重置模式
- 🔄 自动包列表备份和恢复
- 🔍 预览模式支持
- 📦 智能包保护机制

### v1.0 (2024-11-29)
- 🧹 基础缓存清理功能
- 🗑️ 支持主流Python工具
- 📱 简单易用的脚本界面

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE) - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- 感谢所有贡献者和用户的反馈
- 感谢 macOS 和 Python 社区的支持
- 特别感谢测试用户提供的宝贵意见

## 📞 联系方式

- **GitHub Issues**: [问题反馈](https://github.com/your-username/pyreseter/issues)
- **GitHub Discussions**: [讨论交流](https://github.com/your-username/pyreseter/discussions)
- **Email**: your-email@example.com

---

<div align="center">

**⭐ 如果这个项目对您有帮助，请给我们一个星标！**

[⬆️ 回到顶部](#pyreseter)

</div> 