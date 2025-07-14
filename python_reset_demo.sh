#!/bin/bash

# Python环境重置脚本 - 演示模式
# 用于预览清理操作而不实际删除文件
# 作者: AI Assistant
# 版本: 1.0

set -e  # 遇到错误时停止执行

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_success() {
    echo -e "${GREEN}[模拟]${NC} $1"
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
        log_success "将会清理 $description"
    else
        log_info "$description 不存在，跳过"
    fi
}

# 显示脚本头部信息
show_header() {
    echo "========================================"
    echo "  Python环境重置工具 - 演示模式"
    echo "========================================"
    echo ""
    log_demo "这是演示模式，不会实际删除任何文件"
    log_demo "您可以预览将要清理的内容"
    echo ""
    log_info "开始扫描Python缓存和临时文件..."
    echo ""
}

# 检查pip缓存
demo_pip_cache() {
    echo "🗑️  检查pip缓存..."
    
    # pip缓存目录
    local pip_cache_dir="$HOME/Library/Caches/pip"
    check_and_show "$pip_cache_dir" "pip缓存目录"
    
    # 检查pip命令
    if command -v pip >/dev/null 2>&1; then
        log_info "发现pip命令，将使用pip cache purge清理"
    else
        log_info "未发现pip命令"
    fi
    
    # 检查pip3命令
    if command -v pip3 >/dev/null 2>&1; then
        log_info "发现pip3命令，将使用pip3 cache purge清理"
    else
        log_info "未发现pip3命令"
    fi
}

# 检查Poetry缓存
demo_poetry_cache() {
    echo ""
    echo "📦 检查Poetry缓存..."
    
    if command -v poetry >/dev/null 2>&1; then
        log_info "发现poetry命令，将使用poetry cache clear清理"
    else
        log_info "未发现poetry命令"
    fi
    
    # Poetry缓存目录
    local poetry_cache_dir="$HOME/Library/Caches/pypoetry"
    check_and_show "$poetry_cache_dir" "Poetry缓存目录"
}

# 检查conda缓存
demo_conda_cache() {
    echo ""
    echo "🐍 检查Conda缓存..."
    
    if command -v conda >/dev/null 2>&1; then
        log_info "发现conda命令，将使用conda clean --all清理"
    else
        log_info "未发现conda命令"
    fi
    
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
}

# 检查Python字节码文件
demo_python_bytecode() {
    echo ""
    echo "🔥 检查Python字节码文件..."
    
    # 查找__pycache__目录（限制搜索深度以提高速度）
    log_info "搜索__pycache__目录..."
    local pycache_count=$(find "$HOME" -maxdepth 4 -type d -name "__pycache__" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pycache_count" -gt 0 ]; then
        log_found "发现 $pycache_count 个__pycache__目录"
        log_success "将会删除所有__pycache__目录"
    else
        log_info "未发现__pycache__目录"
    fi
    
    # 查找.pyc文件
    log_info "搜索.pyc文件..."
    local pyc_count=$(find "$HOME" -maxdepth 4 -type f -name "*.pyc" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pyc_count" -gt 0 ]; then
        log_found "发现 $pyc_count 个.pyc文件"
        log_success "将会删除所有.pyc文件"
    else
        log_info "未发现.pyc文件"
    fi
    
    # 查找.pyo文件
    log_info "搜索.pyo文件..."
    local pyo_count=$(find "$HOME" -maxdepth 4 -type f -name "*.pyo" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pyo_count" -gt 0 ]; then
        log_found "发现 $pyo_count 个.pyo文件"
        log_success "将会删除所有.pyo文件"
    else
        log_info "未发现.pyo文件"
    fi
}

# 检查测试缓存
demo_test_cache() {
    echo ""
    echo "🧪 检查测试缓存..."
    
    # pytest缓存
    log_info "搜索pytest缓存..."
    local pytest_count=$(find "$HOME" -maxdepth 4 -type d -name ".pytest_cache" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pytest_count" -gt 0 ]; then
        log_found "发现 $pytest_count 个pytest缓存目录"
        log_success "将会删除pytest缓存"
    else
        log_info "未发现pytest缓存"
    fi
    
    # coverage缓存
    log_info "搜索coverage缓存..."
    local coverage_count=$(find "$HOME" -maxdepth 4 -type f -name ".coverage" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$coverage_count" -gt 0 ]; then
        log_found "发现 $coverage_count 个coverage缓存文件"
        log_success "将会删除coverage缓存"
    else
        log_info "未发现coverage缓存"
    fi
}

# 检查Jupyter缓存
demo_jupyter_cache() {
    echo ""
    echo "📓 检查Jupyter缓存..."
    
    local jupyter_dirs=(
        "$HOME/.jupyter/nbsignatures.db"
        "$HOME/.ipython/profile_default/history.sqlite"
        "$HOME/.ipython/profile_default/startup"
    )
    
    for item in "${jupyter_dirs[@]}"; do
        check_and_show "$item" "Jupyter缓存文件"
    done
    
    # 检查Jupyter检查点文件
    log_info "搜索Jupyter检查点文件..."
    local ipynb_count=$(find "$HOME" -maxdepth 4 -type d -name ".ipynb_checkpoints" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ipynb_count" -gt 0 ]; then
        log_found "发现 $ipynb_count 个Jupyter检查点目录"
        log_success "将会删除Jupyter检查点文件"
    else
        log_info "未发现Jupyter检查点文件"
    fi
}

# 检查virtualenv缓存
demo_virtualenv_cache() {
    echo ""
    echo "🏠 检查虚拟环境缓存..."
    
    # virtualenv缓存
    local venv_cache_dir="$HOME/.cache/virtualenv"
    check_and_show "$venv_cache_dir" "virtualenv缓存目录"
    
    # pipenv缓存
    local pipenv_cache_dir="$HOME/.cache/pipenv"
    check_and_show "$pipenv_cache_dir" "pipenv缓存目录"
    
    # virtualenvwrapper缓存
    if [ -n "$WORKON_HOME" ]; then
        log_info "检测到virtualenvwrapper环境: $WORKON_HOME"
    else
        log_info "未检测到virtualenvwrapper环境变量"
    fi
}

# 检查其他Python相关缓存
demo_other_cache() {
    echo ""
    echo "🔧 检查其他Python相关缓存..."
    
    # matplotlib缓存
    local matplotlib_cache="$HOME/.matplotlib"
    check_and_show "$matplotlib_cache" "matplotlib缓存"
    
    # mypy缓存
    log_info "搜索mypy缓存..."
    local mypy_count=$(find "$HOME" -maxdepth 4 -type d -name ".mypy_cache" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$mypy_count" -gt 0 ]; then
        log_found "发现 $mypy_count 个mypy缓存目录"
        log_success "将会删除mypy缓存"
    else
        log_info "未发现mypy缓存"
    fi
    
    # pylint缓存
    log_info "搜索pylint缓存..."
    local pylint_count=$(find "$HOME" -maxdepth 4 -type d -name ".pylint.d" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$pylint_count" -gt 0 ]; then
        log_found "发现 $pylint_count 个pylint缓存目录"
        log_success "将会删除pylint缓存"
    else
        log_info "未发现pylint缓存"
    fi
    
    # tox缓存
    log_info "搜索tox缓存..."
    local tox_count=$(find "$HOME" -maxdepth 4 -type d -name ".tox" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$tox_count" -gt 0 ]; then
        log_found "发现 $tox_count 个tox缓存目录"
        log_success "将会删除tox缓存"
    else
        log_info "未发现tox缓存"
    fi
}

# 验证Python环境
verify_python_env() {
    echo ""
    echo "✅ 当前Python环境状态..."
    
    if command -v python >/dev/null 2>&1; then
        local python_version=$(python --version 2>&1)
        log_found "Python可用: $python_version"
    else
        log_info "Python命令不可用"
    fi
    
    if command -v python3 >/dev/null 2>&1; then
        local python3_version=$(python3 --version 2>&1)
        log_found "Python3可用: $python3_version"
    else
        log_info "Python3命令不可用"
    fi
    
    if command -v pip >/dev/null 2>&1; then
        local pip_version=$(pip --version 2>&1)
        log_found "pip可用: $pip_version"
    else
        log_info "pip命令不可用"
    fi
}

# 显示使用统计
show_stats() {
    echo ""
    echo "📊 演示模式总结..."
    log_demo "这只是预览，没有删除任何文件"
    log_info "要执行实际清理，请运行: ./python_reset.sh"
}

# 主函数
main() {
    # 检查是否为macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}[错误]${NC} 此脚本仅适用于macOS系统"
        exit 1
    fi
    
    show_header
    
    # 执行检查操作
    demo_pip_cache
    demo_poetry_cache
    demo_conda_cache
    demo_python_bytecode
    demo_test_cache
    demo_jupyter_cache
    demo_virtualenv_cache
    demo_other_cache
    
    # 验证环境
    verify_python_env
    
    # 显示统计
    show_stats
    
    echo ""
    echo "========================================"
    log_demo "演示模式完成！"
    echo "========================================"
}

# 如果脚本被直接执行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 