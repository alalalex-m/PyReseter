#!/bin/bash

# PyReseter - Python环境重置工具
# macOS Python Environment Reset Tool
# 版本: 3.0
# 作者: AI Assistant
# 许可: MIT License

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# 版本信息
VERSION="3.0"
GITHUB_REPO="https://github.com/your-username/pyreseter"

# 日志函数
log_info() { echo -e "${BLUE}[信息]${NC} $1"; }
log_success() { echo -e "${GREEN}[成功]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[警告]${NC} $1"; }
log_error() { echo -e "${RED}[错误]${NC} $1"; }
log_critical() { echo -e "${PURPLE}[重要]${NC} $1"; }
log_header() { echo -e "${WHITE}$1${NC}"; }

# 显示横幅
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ____        ____                     __            
   / __ \__  __/ __ \___  ________  ____/ /____  _____
  / /_/ / / / / /_/ / _ \/ ___/ _ \/ __  / _ \/ ___/
 / ____/ /_/ / _, _/  __(__  )  __/ /_/ /  __/ /    
/_/    \__, /_/ |_|\___/____/\___/\__,_/\___/_/     
      /____/                                        
EOF
    echo -e "${NC}"
    echo -e "${WHITE}Python Environment Reset Tool for macOS${NC}"
    echo -e "${BLUE}Version $VERSION${NC}"
    echo -e "${CYAN}$GITHUB_REPO${NC}"
    echo ""
}

# 显示帮助信息
show_help() {
    cat << EOF
用法: ./pyreseter.sh [选项]

选项:
  -h, --help              显示此帮助信息
  -v, --version           显示版本信息
  -p, --preview           只预览，不执行清理
  -c, --cache-only        只清理缓存（温和模式）
  -f, --full-reset        完全重置（删除包+缓存）
  -i, --interactive       交互式模式（默认）
  -q, --quiet             安静模式，减少输出
  --no-backup             不备份包列表（仅完全重置模式）

示例:
  ./pyreseter.sh                    # 交互式模式
  ./pyreseter.sh -p                 # 预览模式
  ./pyreseter.sh -c                 # 只清理缓存
  ./pyreseter.sh -f                 # 完全重置
  ./pyreseter.sh -f --no-backup     # 完全重置且不备份

EOF
}

# 显示版本信息
show_version() {
    echo "PyReseter v$VERSION"
    echo "Python Environment Reset Tool for macOS"
    echo "Copyright (c) 2024"
    echo "License: MIT"
}

# 计算目录大小
get_dir_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1 || echo "0B"
    else
        echo "0B"
    fi
}

# 获取保护包列表
get_protected_packages() {
    echo "pip setuptools wheel distribute six"
}

# 安全删除函数
safe_remove() {
    local path="$1"
    local description="$2"
    local quiet="${3:-false}"
    
    if [ -e "$path" ]; then
        local size=$(get_dir_size "$path")
        [ "$quiet" != "true" ] && log_info "正在清理 $description ($size)..."
        rm -rf "$path" 2>/dev/null && {
            [ "$quiet" != "true" ] && log_success "已清理 $description"
        } || {
            [ "$quiet" != "true" ] && log_warning "无法清理 $description"
        }
        return 0
    else
        [ "$quiet" != "true" ] && log_info "$description 不存在，跳过"
        return 1
    fi
}

# 创建备份目录
create_backup_dir() {
    local backup_dir="$HOME/.python_reset_backup"
    local timestamp=$(date "+%Y%m%d_%H%M%S")
    local session_backup_dir="$backup_dir/$timestamp"
    
    mkdir -p "$session_backup_dir"
    echo "$session_backup_dir"
}

# 备份包列表
backup_packages() {
    local backup_dir="$1"
    local quiet="${2:-false}"
    
    [ "$quiet" != "true" ] && log_info "备份当前已安装的包列表..."
    
    # 备份pip包
    if command -v pip >/dev/null 2>&1; then
        pip list --format=freeze > "$backup_dir/pip_packages.txt" 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "已备份pip包列表"; } || \
            { [ "$quiet" != "true" ] && log_warning "备份pip包列表失败"; }
    fi
    
    # 备份pip3包
    if command -v pip3 >/dev/null 2>&1; then
        pip3 list --format=freeze > "$backup_dir/pip3_packages.txt" 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "已备份pip3包列表"; } || \
            { [ "$quiet" != "true" ] && log_warning "备份pip3包列表失败"; }
    fi
    
    # 备份conda包
    if command -v conda >/dev/null 2>&1; then
        conda list --export > "$backup_dir/conda_packages.txt" 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "已备份conda包列表"; } || \
            { [ "$quiet" != "true" ] && log_warning "备份conda包列表失败"; }
    fi
}

# 清理pip缓存
clean_pip_cache() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "🗑️  清理pip缓存..."
    
    safe_remove "$HOME/Library/Caches/pip" "pip缓存目录" "$quiet"
    
    if command -v pip >/dev/null 2>&1; then
        [ "$quiet" != "true" ] && log_info "使用pip命令清理缓存..."
        pip cache purge 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "pip缓存已清理"; } || \
            { [ "$quiet" != "true" ] && log_warning "pip缓存清理失败"; }
    fi
    
    if command -v pip3 >/dev/null 2>&1; then
        [ "$quiet" != "true" ] && log_info "使用pip3命令清理缓存..."
        pip3 cache purge 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "pip3缓存已清理"; } || \
            { [ "$quiet" != "true" ] && log_warning "pip3缓存清理失败"; }
    fi
}

# 清理Poetry缓存
clean_poetry_cache() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "📦 清理Poetry缓存..."
    
    if command -v poetry >/dev/null 2>&1; then
        [ "$quiet" != "true" ] && log_info "使用poetry命令清理缓存..."
        poetry cache clear --all . 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "Poetry缓存已清理"; } || \
            { [ "$quiet" != "true" ] && log_warning "Poetry缓存清理失败"; }
    fi
    
    safe_remove "$HOME/Library/Caches/pypoetry" "Poetry缓存目录" "$quiet"
}

# 清理conda缓存
clean_conda_cache() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "🐍 清理Conda缓存..."
    
    if command -v conda >/dev/null 2>&1; then
        [ "$quiet" != "true" ] && log_info "使用conda命令清理缓存..."
        conda clean --all --yes 2>/dev/null && \
            { [ "$quiet" != "true" ] && log_success "Conda缓存已清理"; } || \
            { [ "$quiet" != "true" ] && log_warning "Conda缓存清理失败"; }
    fi
    
    local conda_dirs=(
        "$HOME/.conda/pkgs"
        "$HOME/.conda/envs/.conda_envs_dir_test"
        "$HOME/anaconda3/pkgs"
        "$HOME/miniconda3/pkgs"
    )
    
    for dir in "${conda_dirs[@]}"; do
        safe_remove "$dir" "Conda缓存目录" "$quiet"
    done
}

# 清理Python字节码
clean_bytecode() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "🔥 清理Python字节码文件..."
    
    [ "$quiet" != "true" ] && log_info "查找并删除__pycache__目录..."
    find "$HOME" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除__pycache__目录"; } || \
        { [ "$quiet" != "true" ] && log_warning "删除__pycache__目录时遇到问题"; }
    
    [ "$quiet" != "true" ] && log_info "查找并删除.pyc/.pyo文件..."
    find "$HOME" -type f \( -name "*.pyc" -o -name "*.pyo" \) -delete 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除字节码文件"; } || \
        { [ "$quiet" != "true" ] && log_warning "删除字节码文件时遇到问题"; }
}

# 清理测试缓存
clean_test_cache() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "🧪 清理测试缓存..."
    
    find "$HOME" -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除pytest缓存"; } || true
    
    find "$HOME" -type f -name ".coverage" -delete 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除coverage缓存"; } || true
    
    find "$HOME" -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除htmlcov目录"; } || true
}

# 清理其他缓存
clean_other_cache() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "🔧 清理其他缓存..."
    
    safe_remove "$HOME/.matplotlib" "matplotlib缓存" "$quiet"
    safe_remove "$HOME/.cache/virtualenv" "virtualenv缓存" "$quiet"
    safe_remove "$HOME/.cache/pipenv" "pipenv缓存" "$quiet"
    
    find "$HOME" -type d \( -name ".mypy_cache" -o -name ".pylint.d" -o -name ".tox" \) -exec rm -rf {} + 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除开发工具缓存"; } || true
    
    find "$HOME" -type d -name ".ipynb_checkpoints" -exec rm -rf {} + 2>/dev/null && \
        { [ "$quiet" != "true" ] && log_success "已删除Jupyter检查点"; } || true
}

# 清理用户包
clean_user_packages() {
    local quiet="${1:-false}"
    [ "$quiet" != "true" ] && echo "📦 清理用户安装的Python包..."
    
    local protected_packages=$(get_protected_packages)
    
    if command -v pip >/dev/null 2>&1; then
        local all_packages=$(pip list --format=freeze 2>/dev/null | cut -d'=' -f1 | grep -v "^-e" || echo "")
        
        if [ -n "$all_packages" ]; then
            local packages_to_remove=""
            while read -r package; do
                if [ -n "$package" ] && ! echo "$protected_packages" | grep -wq "$package"; then
                    packages_to_remove="$packages_to_remove $package"
                fi
            done <<< "$all_packages"
            
            if [ -n "$packages_to_remove" ]; then
                [ "$quiet" != "true" ] && log_info "批量卸载用户包..."
                pip uninstall $packages_to_remove -y 2>/dev/null && \
                    { [ "$quiet" != "true" ] && log_success "用户包已卸载"; } || \
                    { [ "$quiet" != "true" ] && log_warning "部分包卸载失败"; }
            fi
        fi
    fi
    
    # 重新安装基础包
    if command -v pip >/dev/null 2>&1; then
        [ "$quiet" != "true" ] && log_info "重新安装基础包..."
        for pkg in pip setuptools wheel; do
            pip install --upgrade "$pkg" 2>/dev/null && \
                { [ "$quiet" != "true" ] && log_success "已升级: $pkg"; } || \
                { [ "$quiet" != "true" ] && log_warning "升级失败: $pkg"; }
        done
    fi
}

# 预览模式
preview_cleanup() {
    local mode="$1"
    
    show_banner
    log_header "=== 预览模式 ==="
    echo ""
    
    # 显示当前环境状态
    log_info "当前Python环境状态:"
    command -v python >/dev/null && echo "  Python: $(python --version 2>&1)"
    command -v pip >/dev/null && echo "  pip: $(pip --version 2>&1 | cut -d' ' -f1-2)"
    command -v pip >/dev/null && echo "  已安装包: $(pip list 2>/dev/null | wc -l | tr -d ' ') 个"
    echo ""
    
    # 预览缓存
    log_info "将要清理的缓存:"
    [ -d "$HOME/Library/Caches/pip" ] && echo "  pip缓存: $(get_dir_size "$HOME/Library/Caches/pip")"
    [ -d "$HOME/Library/Caches/pypoetry" ] && echo "  Poetry缓存: $(get_dir_size "$HOME/Library/Caches/pypoetry")"
    [ -d "$HOME/.matplotlib" ] && echo "  matplotlib缓存: $(get_dir_size "$HOME/.matplotlib")"
    
    local pycache_count=$(find "$HOME" -maxdepth 4 -type d -name "__pycache__" 2>/dev/null | wc -l | tr -d ' ')
    [ "$pycache_count" -gt 0 ] && echo "  __pycache__目录: $pycache_count 个"
    
    # 如果是完全重置模式，显示包信息
    if [ "$mode" = "full" ]; then
        echo ""
        log_critical "⚠️  完全重置模式将删除所有用户安装的包！"
        if command -v pip >/dev/null 2>&1; then
            local total_packages=$(pip list --format=freeze 2>/dev/null | wc -l)
            local protected_count=$(echo "$(get_protected_packages)" | wc -w)
            echo "  总包数: $total_packages"
            echo "  保护包数: $protected_count"
            echo "  将删除: $((total_packages - protected_count)) 个包"
        fi
    fi
    
    echo ""
    log_info "这只是预览，没有执行任何清理操作"
}

# 执行清理
perform_cleanup() {
    local mode="$1"
    local no_backup="${2:-false}"
    local quiet="${3:-false}"
    
    [ "$quiet" != "true" ] && show_banner
    [ "$quiet" != "true" ] && log_header "=== 开始清理 ==="
    
    local backup_dir=""
    
    # 如果是完全重置且需要备份
    if [ "$mode" = "full" ] && [ "$no_backup" != "true" ]; then
        backup_dir=$(create_backup_dir)
        [ "$quiet" != "true" ] && log_info "备份目录: $backup_dir"
        backup_packages "$backup_dir" "$quiet"
        echo ""
    fi
    
    # 执行清理
    if [ "$mode" = "full" ]; then
        clean_user_packages "$quiet"
    fi
    
    clean_pip_cache "$quiet"
    clean_poetry_cache "$quiet"
    clean_conda_cache "$quiet"
    clean_bytecode "$quiet"
    clean_test_cache "$quiet"
    clean_other_cache "$quiet"
    
    # 显示结果
    [ "$quiet" != "true" ] && echo ""
    [ "$quiet" != "true" ] && log_header "=== 清理完成 ==="
    [ "$quiet" != "true" ] && log_success "Python环境清理完成！"
    
    if [ "$mode" = "full" ] && [ "$no_backup" != "true" ] && [ -n "$backup_dir" ]; then
        [ "$quiet" != "true" ] && echo ""
        [ "$quiet" != "true" ] && log_info "恢复命令:"
        [ "$quiet" != "true" ] && echo "  pip install -r $backup_dir/pip_packages.txt"
    fi
    
    [ "$quiet" != "true" ] && echo ""
    [ "$quiet" != "true" ] && log_info "建议重启终端以确保所有更改生效"
}

# 交互式菜单
interactive_menu() {
    while true; do
        show_banner
        log_header "=== 选择清理模式 ==="
        echo ""
        echo "1) 🔍 预览缓存清理（安全查看）"
        echo "2) 🧹 执行缓存清理（温和模式）"
        echo "3) 🔍 预览完全重置（安全查看）"
        echo "4) 💥 执行完全重置（删除包+缓存）"
        echo "5) ❓ 帮助信息"
        echo "6) 🚪 退出"
        echo ""
        
        read -p "$(echo -e "${YELLOW}请选择 [1-6]: ${NC}")" choice
        
        case $choice in
            1)
                preview_cleanup "cache"
                echo ""
                read -p "按Enter键继续..." 
                ;;
            2)
                echo ""
                log_warning "即将执行缓存清理..."
                read -p "$(echo -e "${YELLOW}确认继续？[y/N]: ${NC}")" -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    perform_cleanup "cache" "false" "false"
                    echo ""
                    read -p "按Enter键继续..."
                fi
                ;;
            3)
                preview_cleanup "full"
                echo ""
                read -p "按Enter键继续..."
                ;;
            4)
                echo ""
                log_critical "⚠️  警告：完全重置将删除所有用户安装的包！"
                echo "   - 将备份包列表到 ~/.python_reset_backup/"
                echo "   - 保留系统必需包（pip、setuptools等）"
                echo "   - 可通过备份文件恢复包"
                echo ""
                read -p "$(echo -e "${YELLOW}确认继续？[y/N]: ${NC}")" -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    perform_cleanup "full" "false" "false"
                    echo ""
                    read -p "按Enter键继续..."
                fi
                ;;
            5)
                clear
                show_help
                echo ""
                read -p "按Enter键继续..."
                ;;
            6)
                log_info "谢谢使用 PyReseter！"
                exit 0
                ;;
            *)
                log_error "无效选择，请输入 1-6"
                sleep 1
                ;;
        esac
    done
}

# 主函数
main() {
    # 检查macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "此工具仅适用于macOS系统"
        exit 1
    fi
    
    # 解析命令行参数
    local preview_mode=false
    local cache_only=false
    local full_reset=false
    local interactive=true
    local quiet=false
    local no_backup=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -p|--preview)
                preview_mode=true
                interactive=false
                shift
                ;;
            -c|--cache-only)
                cache_only=true
                interactive=false
                shift
                ;;
            -f|--full-reset)
                full_reset=true
                interactive=false
                shift
                ;;
            -i|--interactive)
                interactive=true
                shift
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            --no-backup)
                no_backup=true
                shift
                ;;
            *)
                log_error "未知参数: $1"
                echo "使用 --help 查看帮助信息"
                exit 1
                ;;
        esac
    done
    
    # 执行相应操作
    if [ "$interactive" = true ]; then
        interactive_menu
    elif [ "$preview_mode" = true ]; then
        if [ "$full_reset" = true ]; then
            preview_cleanup "full"
        else
            preview_cleanup "cache"
        fi
    elif [ "$cache_only" = true ]; then
        perform_cleanup "cache" "$no_backup" "$quiet"
    elif [ "$full_reset" = true ]; then
        if [ "$quiet" != "true" ]; then
            log_critical "⚠️  警告：完全重置将删除所有用户安装的包！"
            read -p "$(echo -e "${YELLOW}确认继续？[y/N]: ${NC}")" -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "操作已取消"
                exit 0
            fi
        fi
        perform_cleanup "full" "$no_backup" "$quiet"
    else
        interactive_menu
    fi
}

# 执行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 