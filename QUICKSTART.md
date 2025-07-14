# 🚀 PyReseter 快速开始

## 一行命令运行

```bash
# 下载并运行（推荐）
curl -O https://raw.githubusercontent.com/your-username/pyreseter/main/pyreseter.sh && chmod +x pyreseter.sh && ./pyreseter.sh
```

## 常用命令

| 需求 | 命令 | 说明 |
|------|------|------|
| **交互式菜单** | `./pyreseter.sh` | 新手友好的图形界面 |
| **日常清理** | `./pyreseter.sh -c` | 清理缓存，保留包 |
| **安全预览** | `./pyreseter.sh -p` | 查看将要清理什么 |
| **深度重置** | `./pyreseter.sh -f` | 删除包+缓存（有备份） |
| **静默清理** | `./pyreseter.sh -c -q` | 适合脚本自动化 |

## 🔥 立即体验

1. **下载工具**
   ```bash
   git clone https://github.com/your-username/pyreseter.git
   cd pyreseter
   chmod +x pyreseter.sh
   ```

2. **安全预览**（看看能释放多少空间）
   ```bash
   ./pyreseter.sh -p
   ```

3. **开始清理**
   ```bash
   ./pyreseter.sh -c  # 温和清理
   # 或
   ./pyreseter.sh -f  # 完全重置
   ```

## 🎯 适用场景

- **💾 磁盘空间不足** → 使用 `-c` 清理缓存
- **🐛 Python环境异常** → 使用 `-f` 完全重置  
- **🧹 定期维护** → 每月运行 `-c` 模式
- **🚀 项目开始前** → 使用 `-f` 获得干净环境

## ⚡ 实际效果

根据您的系统测试结果：
- 🗑️ **释放空间**: 960MB+ 
- 📦 **删除包**: 101个用户包
- 🛡️ **安全保护**: 自动保护5个系统包
- 🔄 **快速恢复**: 自动备份，一键恢复

开始使用 PyReseter，让您的 Python 环境更干净、更快速！ 