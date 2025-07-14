#!/bin/bash

# Python环境重置脚本 - macOS版本
# 用于清理所有Python相关的缓存和临时文件
# 作者: AI Assistant
# 版本: 1.0

set -e  # 遇到错误时停止执行

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

log_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 计算目录大小的函数
get_dir_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
    else
        echo "0B"
    fi
}

# 安全删除函数
safe_remove() {
    local path="$1"
    local description="$2"
    
    if [ -e "$path" ]; then
        local size=$(get_dir_size "$path")
        log_info "正在清理 $description ($size)..."
        rm -rf "$path" 2>/dev/null && log_success "已清理 $description" || log_warning "无法清理 $description"
    else
        log_info "$description 不存在，跳过"
    fi
}

# 显示脚本头部信息
show_header() {
    echo "========================================"
    echo "    Python环境重置工具 - macOS版本"
    echo "========================================"
    echo ""
    log_info "开始清理Python缓存和临时文件..."
    echo ""
}

# 清理pip缓存
clean_pip_cache() {
    echo "🗑️  清理pip缓存..."
    
    # pip缓存目录
    local pip_cache_dir="$HOME/Library/Caches/pip"
    safe_remove "$pip_cache_dir" "pip缓存目录"
    
    # 使用pip命令清理缓存
    if command -v pip >/dev/null 2>&1; then
        log_info "使用pip命令清理缓存..."
        pip cache purge 2>/dev/null && log_success "pip缓存已清理" || log_warning "pip缓存清理失败"
    fi
    
    # 清理pip3缓存
    if command -v pip3 >/dev/null 2>&1; then
        log_info "使用pip3命令清理缓存..."
        pip3 cache purge 2>/dev/null && log_success "pip3缓存已清理" || log_warning "pip3缓存清理失败"
    fi
}

# 清理Poetry缓存
clean_poetry_cache() {
    echo ""
    echo "📦 清理Poetry缓存..."
    
    if command -v poetry >/dev/null 2>&1; then
        log_info "使用poetry命令清理缓存..."
        poetry cache clear --all . 2>/dev/null && log_success "Poetry缓存已清理" || log_warning "Poetry缓存清理失败"
    fi
    
    # Poetry缓存目录
    local poetry_cache_dir="$HOME/Library/Caches/pypoetry"
    safe_remove "$poetry_cache_dir" "Poetry缓存目录"
}

# 清理conda缓存
clean_conda_cache() {
    echo ""
    echo "🐍 清理Conda缓存..."
    
    if command -v conda >/dev/null 2>&1; then
        log_info "使用conda命令清理缓存..."
        conda clean --all --yes 2>/dev/null && log_success "Conda缓存已清理" || log_warning "Conda缓存清理失败"
    fi
    
    # Conda缓存目录
    local conda_cache_dirs=(
        "$HOME/.conda/pkgs"
        "$HOME/.conda/envs/.conda_envs_dir_test"
        "$HOME/anaconda3/pkgs"
        "$HOME/miniconda3/pkgs"
    )
    
    for dir in "${conda_cache_dirs[@]}"; do
        if [ -d "$dir" ]; then
            safe_remove "$dir" "Conda包缓存目录 ($dir)"
        fi
    done
}

# 清理Python字节码文件
clean_python_bytecode() {
    echo ""
    echo "🔥 清理Python字节码文件..."
    
    # 查找并删除__pycache__目录
    log_info "查找并删除__pycache__目录..."
    find "$HOME" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除所有__pycache__目录" || log_warning "删除__pycache__目录时遇到问题"
    
    # 查找并删除.pyc文件
    log_info "查找并删除.pyc文件..."
    find "$HOME" -type f -name "*.pyc" -delete 2>/dev/null && \
        log_success "已删除所有.pyc文件" || log_warning "删除.pyc文件时遇到问题"
    
    # 查找并删除.pyo文件
    log_info "查找并删除.pyo文件..."
    find "$HOME" -type f -name "*.pyo" -delete 2>/dev/null && \
        log_success "已删除所有.pyo文件" || log_warning "删除.pyo文件时遇到问题"
}

# 清理测试缓存
clean_test_cache() {
    echo ""
    echo "🧪 清理测试缓存..."
    
    # pytest缓存
    log_info "查找并删除pytest缓存..."
    find "$HOME" -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除pytest缓存" || log_warning "删除pytest缓存时遇到问题"
    
    # coverage缓存
    log_info "查找并删除coverage缓存..."
    find "$HOME" -type f -name ".coverage" -delete 2>/dev/null && \
        log_success "已删除coverage缓存" || log_warning "删除coverage缓存时遇到问题"
    
    find "$HOME" -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除htmlcov目录" || log_warning "删除htmlcov目录时遇到问题"
}

# 清理Jupyter缓存
clean_jupyter_cache() {
    echo ""
    echo "📓 清理Jupyter缓存..."
    
    local jupyter_dirs=(
        "$HOME/.jupyter/nbsignatures.db"
        "$HOME/.ipython/profile_default/history.sqlite"
        "$HOME/.ipython/profile_default/startup"
    )
    
    for item in "${jupyter_dirs[@]}"; do
        safe_remove "$item" "Jupyter缓存文件 ($item)"
    done
    
    # 清理Jupyter运行时文件
    find "$HOME" -type f -name "*.ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除Jupyter检查点文件" || log_warning "删除Jupyter检查点文件时遇到问题"
}

# 清理virtualenv缓存
clean_virtualenv_cache() {
    echo ""
    echo "🏠 清理虚拟环境缓存..."
    
    # virtualenv缓存
    local venv_cache_dir="$HOME/.cache/virtualenv"
    safe_remove "$venv_cache_dir" "virtualenv缓存目录"
    
    # pipenv缓存
    local pipenv_cache_dir="$HOME/.cache/pipenv"
    safe_remove "$pipenv_cache_dir" "pipenv缓存目录"
    
    # virtualenvwrapper缓存
    if [ -n "$WORKON_HOME" ]; then
        log_info "检查virtualenvwrapper环境: $WORKON_HOME"
    fi
}

# 清理其他Python相关缓存
clean_other_cache() {
    echo ""
    echo "🔧 清理其他Python相关缓存..."
    
    # matplotlib缓存
    local matplotlib_cache="$HOME/.matplotlib"
    safe_remove "$matplotlib_cache" "matplotlib缓存"
    
    # mypy缓存
    find "$HOME" -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除mypy缓存" || log_warning "删除mypy缓存时遇到问题"
    
    # pylint缓存
    find "$HOME" -type d -name ".pylint.d" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除pylint缓存" || log_warning "删除pylint缓存时遇到问题"
    
    # bandit缓存
    find "$HOME" -type f -name ".bandit" -delete 2>/dev/null && \
        log_success "已删除bandit缓存" || log_warning "删除bandit缓存时遇到问题"
    
    # tox缓存
    find "$HOME" -type d -name ".tox" -exec rm -rf {} + 2>/dev/null && \
        log_success "已删除tox缓存" || log_warning "删除tox缓存时遇到问题"
}

# 验证Python环境
verify_python_env() {
    echo ""
    echo "✅ 验证Python环境..."
    
    if command -v python >/dev/null 2>&1; then
        local python_version=$(python --version 2>&1)
        log_success "Python可用: $python_version"
    else
        log_warning "Python命令不可用"
    fi
    
    if command -v python3 >/dev/null 2>&1; then
        local python3_version=$(python3 --version 2>&1)
        log_success "Python3可用: $python3_version"
    else
        log_warning "Python3命令不可用"
    fi
    
    if command -v pip >/dev/null 2>&1; then
        local pip_version=$(pip --version 2>&1)
        log_success "pip可用: $pip_version"
    else
        log_warning "pip命令不可用"
    fi
}

# 显示使用统计
show_stats() {
    echo ""
    echo "📊 清理统计..."
    log_info "清理操作已完成"
    log_info "建议重启终端以确保所有更改生效"
}

# 主函数
main() {
    # 检查是否为macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "此脚本仅适用于macOS系统"
        exit 1
    fi
    
    show_header
    
    # 执行清理操作
    clean_pip_cache
    clean_poetry_cache
    clean_conda_cache
    clean_python_bytecode
    clean_test_cache
    clean_jupyter_cache
    clean_virtualenv_cache
    clean_other_cache
    
    # 验证环境
    verify_python_env
    
    # 显示统计
    show_stats
    
    echo ""
    echo "========================================"
    log_success "Python环境重置完成！"
    echo "========================================"
}

# 如果脚本被直接执行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 