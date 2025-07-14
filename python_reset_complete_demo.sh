#!/bin/bash

# Python环境完全重置脚本 - 演示模式
# 用于预览所有将要删除的缓存和包
# 作者: AI Assistant
# 版本: 2.0

set -e  # 遇到错误时停止执行

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

log_demo() {
    echo -e "${CYAN}[演示]${NC} $1"
}

log_found() {
    echo -e "${YELLOW}[发现]${NC} $1"
}

log_critical() {
    echo -e "${PURPLE}[重要]${NC} $1"
}

log_package() {
    echo -e "${GREEN}[包]${NC} $1"
}

# 计算目录大小的函数
get_dir_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
    else
        echo "0B"
    fi
}

# 检查文件或目录是否存在并显示信息
check_and_show() {
    local path="$1"
    local description="$2"
    
    if [ -e "$path" ]; then
        local size=$(get_dir_size "$path")
        log_found "$description 存在 ($size): $path"
    else
        log_info "$description 不存在，跳过"
    fi
}

# 显示脚本头部信息
show_header() {
    echo "========================================"
    echo " Python环境完全重置工具 - 演示模式"
    echo "========================================"
    echo ""
    log_demo "这是演示模式，不会实际删除任何文件或包"
    log_demo "您可以预览将要清理的所有内容"
    echo ""
    log_critical "完全重置模式将删除所有缓存和用户安装的包！"
    echo ""
    log_info "开始扫描Python环境..."
    echo ""
}

# 获取要保护的系统包列表
get_protected_packages() {
    echo "pip setuptools wheel distribute six"
}

# 预览将要删除的包
preview_packages_to_remove() {
    echo ""
    echo "📦 预览将要删除的Python包..."
    
    local protected_packages=$(get_protected_packages)
    local total_packages=0
    local protected_count=0
    local to_remove_count=0
    
    if command -v pip >/dev/null 2>&1; then
        log_info "分析pip安装的包..."
        
        # 获取所有包
        local all_packages=$(pip list --format=freeze 2>/dev/null | cut -d'=' -f1 | grep -v "^-e" || echo "")
        
        if [ -n "$all_packages" ]; then
            echo ""
            log_found "当前已安装的包列表:"
            echo "$all_packages" | while read -r package; do
                if [ -n "$package" ]; then
                    total_packages=$((total_packages + 1))
                    # 检查是否为受保护的包
                    if echo "$protected_packages" | grep -wq "$package"; then
                        log_info "  ✅ 保留: $package (系统包)"
                        protected_count=$((protected_count + 1))
                    else
                        log_package "  ❌ 将删除: $package"
                        to_remove_count=$((to_remove_count + 1))
                    fi
                fi
            done
            
            echo ""
            log_critical "包统计:"
            echo "  - 总包数: $(echo "$all_packages" | wc -l | tr -d ' ')"
            echo "  - 受保护包: $(echo "$protected_packages" | wc -w)"
            echo "  - 将删除包: $(($(echo "$all_packages" | wc -l | tr -d ' ') - $(echo "$protected_packages" | wc -w)))"
        else
            log_info "未发现已安装的包"
        fi
        
        # 显示用户安装的包
        local user_packages=$(pip list --user --format=freeze 2>/dev/null | cut -d'=' -f1 || echo "")
        if [ -n "$user_packages" ] && [ "$user_packages" != "" ]; then
            echo ""
            log_found "用户安装的包 (--user):"
            echo "$user_packages" | while read -r package; do
                if [ -n "$package" ]; then
                    log_package "  - $package"
                fi
            done
        fi
    else
        log_info "pip命令不可用"
    fi
    
    # 检查pip3（如果pip不存在）
    if command -v pip3 >/dev/null 2>&1 && ! command -v pip >/dev/null 2>&1; then
        log_info "分析pip3安装的包..."
        
        local all_packages=$(pip3 list --format=freeze 2>/dev/null | cut -d'=' -f1 | grep -v "^-e" || echo "")
        
        if [ -n "$all_packages" ]; then
            echo ""
            log_found "pip3当前已安装的包:"
            echo "$all_packages" | while read -r package; do
                if [ -n "$package" ]; then
                    # 检查是否为受保护的包
                    if echo "$protected_packages" | grep -wq "$package"; then
                        log_info "  ✅ 保留: $package (系统包)"
                    else
                        log_package "  ❌ 将删除: $package"
                    fi
                fi
            done
        fi
    fi
}

# 预览缓存清理
preview_cache_cleanup() {
    echo ""
    echo "🗑️  预览缓存清理..."
    
    # pip缓存
    local pip_cache_dir="$HOME/Library/Caches/pip"
    check_and_show "$pip_cache_dir" "pip缓存目录"
    
    # Poetry缓存
    local poetry_cache_dir="$HOME/Library/Caches/pypoetry"
    check_and_show "$poetry_cache_dir" "Poetry缓存目录"
    
    # Conda缓存目录
    local conda_cache_dirs=(
        "$HOME/.conda/pkgs"
        "$HOME/.conda/envs/.conda_envs_dir_test"
        "$HOME/anaconda3/pkgs"
        "$HOME/miniconda3/pkgs"
    )
    
    for dir in "${conda_cache_dirs[@]}"; do
        check_and_show "$dir" "Conda缓存目录"
    done
    
    # matplotlib缓存
    local matplotlib_cache="$HOME/.matplotlib"
    check_and_show "$matplotlib_cache" "matplotlib缓存"
}

# 预览字节码文件
preview_bytecode_cleanup() {
    echo ""
    echo "🔥 预览字节码文件清理..."
    
    # 查找__pycache__目录（限制搜索深度以提高速度）
    log_info "搜索__pycache__目录..."
    local pycache_count=$(find "$HOME" -maxdepth 4 -type d -name "__pycache__" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pycache_count" -gt 0 ]; then
        log_found "发现 $pycache_count 个__pycache__目录"
        # 显示前5个作为示例
        log_info "示例目录:"
        find "$HOME" -maxdepth 4 -type d -name "__pycache__" 2>/dev/null | head -5 | while read -r dir; do
            local size=$(get_dir_size "$dir")
            echo "  - $dir ($size)"
        done
    else
        log_info "未发现__pycache__目录"
    fi
    
    # 查找.pyc文件
    log_info "搜索.pyc文件..."
    local pyc_count=$(find "$HOME" -maxdepth 4 -type f -name "*.pyc" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pyc_count" -gt 0 ]; then
        log_found "发现 $pyc_count 个.pyc文件"
    else
        log_info "未发现.pyc文件"
    fi
}

# 预览其他缓存
preview_other_cleanup() {
    echo ""
    echo "🔧 预览其他清理项目..."
    
    # 测试缓存
    local pytest_count=$(find "$HOME" -maxdepth 4 -type d -name ".pytest_cache" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pytest_count" -gt 0 ]; then
        log_found "pytest缓存: $pytest_count 个目录"
    fi
    
    # jupyter检查点
    local ipynb_count=$(find "$HOME" -maxdepth 4 -type d -name ".ipynb_checkpoints" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ipynb_count" -gt 0 ]; then
        log_found "Jupyter检查点: $ipynb_count 个目录"
    fi
    
    # mypy缓存
    local mypy_count=$(find "$HOME" -maxdepth 4 -type d -name ".mypy_cache" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$mypy_count" -gt 0 ]; then
        log_found "mypy缓存: $mypy_count 个目录"
    fi
    
    # 虚拟环境缓存
    local venv_dirs=(
        "$HOME/.cache/virtualenv"
        "$HOME/.cache/pipenv"
    )
    
    for dir in "${venv_dirs[@]}"; do
        if [ -d "$dir" ]; then
            local size=$(get_dir_size "$dir")
            log_found "虚拟环境缓存: $dir ($size)"
        fi
    done
}

# 显示当前Python环境状态
show_current_env() {
    echo ""
    echo "✅ 当前Python环境状态..."
    
    if command -v python >/dev/null 2>&1; then
        local python_version=$(python --version 2>&1)
        log_found "Python: $python_version"
    fi
    
    if command -v python3 >/dev/null 2>&1; then
        local python3_version=$(python3 --version 2>&1)
        log_found "Python3: $python3_version"
    fi
    
    if command -v pip >/dev/null 2>&1; then
        local pip_version=$(pip --version 2>&1 | cut -d' ' -f1-2)
        log_found "pip: $pip_version"
        
        local total_packages=$(pip list 2>/dev/null | wc -l | tr -d ' ')
        log_found "已安装包总数: $total_packages"
    fi
    
    if command -v conda >/dev/null 2>&1; then
        local conda_version=$(conda --version 2>&1)
        log_found "conda: $conda_version"
    fi
    
    if command -v poetry >/dev/null 2>&1; then
        local poetry_version=$(poetry --version 2>&1)
        log_found "poetry: $poetry_version"
    fi
}

# 显示预计节省的空间
show_space_estimation() {
    echo ""
    echo "💾 预计释放的磁盘空间..."
    
    local total_size=0
    
    # 计算缓存大小
    local pip_cache_dir="$HOME/Library/Caches/pip"
    if [ -d "$pip_cache_dir" ]; then
        local pip_size=$(du -sm "$pip_cache_dir" 2>/dev/null | cut -f1 || echo "0")
        log_info "pip缓存: ${pip_size}MB"
        total_size=$((total_size + pip_size))
    fi
    
    local poetry_cache_dir="$HOME/Library/Caches/pypoetry"
    if [ -d "$poetry_cache_dir" ]; then
        local poetry_size=$(du -sm "$poetry_cache_dir" 2>/dev/null | cut -f1 || echo "0")
        log_info "Poetry缓存: ${poetry_size}MB"
        total_size=$((total_size + poetry_size))
    fi
    
    local matplotlib_cache="$HOME/.matplotlib"
    if [ -d "$matplotlib_cache" ]; then
        local matplotlib_size=$(du -sm "$matplotlib_cache" 2>/dev/null | cut -f1 || echo "0")
        log_info "matplotlib缓存: ${matplotlib_size}MB"
        total_size=$((total_size + matplotlib_size))
    fi
    
    echo ""
    log_critical "预计总共释放: ${total_size}MB 磁盘空间"
    log_demo "注意: 不包括将要删除的包占用的空间"
}

# 显示总结
show_summary() {
    echo ""
    echo "📊 演示模式总结..."
    log_demo "以上是完全重置模式将要执行的操作"
    log_critical "⚠️  实际执行将会："
    echo "   1. 备份当前包列表到 ~/.python_reset_backup/"
    echo "   2. 删除所有非系统Python包"
    echo "   3. 清理所有缓存和临时文件"
    echo "   4. 重新安装基础包 (pip, setuptools, wheel)"
    echo "   5. 提供恢复命令"
    echo ""
    log_info "要执行实际清理，请运行: ./python_reset_complete.sh"
    log_info "要执行温和清理（仅缓存），请运行: ./python_reset.sh"
}

# 主函数
main() {
    # 检查是否为macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}[错误]${NC} 此脚本仅适用于macOS系统"
        exit 1
    fi
    
    show_header
    
    # 显示当前环境状态
    show_current_env
    
    # 预览包删除
    preview_packages_to_remove
    
    # 预览缓存清理
    preview_cache_cleanup
    
    # 预览字节码清理
    preview_bytecode_cleanup
    
    # 预览其他清理
    preview_other_cleanup
    
    # 显示空间估算
    show_space_estimation
    
    # 显示总结
    show_summary
    
    echo ""
    echo "========================================"
    log_demo "完全重置演示模式完成！"
    echo "========================================"
}

# 如果脚本被直接执行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 