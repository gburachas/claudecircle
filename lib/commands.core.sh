#!/usr/bin/env bash
# Core Commands - Essential ClaudeCircle operations
# ============================================================================
# Commands: help, shell, update
# These are the fundamental commands that users interact with most

# Show help function
_cmd_help() {
    # Set up IMAGE_NAME if we're in a project directory
    if [[ -n "${PROJECT_DIR:-}" ]]; then
        # Initialize project directory to ensure parent exists
        init_project_dir "$PROJECT_DIR"
        IMAGE_NAME=$(get_image_name 2>/dev/null || echo "")
    fi
    
    # Check for subcommands
    local subcommand="${1:-}"
    
    case "$subcommand" in
        "full")
            show_full_help
            ;;
        "claude")
            show_claude_help
            ;;
        "")
            # Default behavior - check if we have project and show appropriate help
            local project_folder_name
            project_folder_name=$(get_project_folder_name "$PROJECT_DIR" 2>/dev/null || echo "NONE")
            
            if [[ "$project_folder_name" != "NONE" ]] && [[ -n "${IMAGE_NAME:-}" ]] && docker image inspect "$IMAGE_NAME" &>/dev/null; then
                # In project directory with image - show Claude help
                show_claude_help
            else
                # Not in project directory - show ClaudeCircle help
                show_help
            fi
            ;;
        *)
            # Unknown subcommand - show regular help
            show_help
            ;;
    esac
    
    exit 0
}

_cmd_shell() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "[DEBUG] _cmd_shell called with args: $*" >&2
    fi
    
    # Set up slot variables if not already set
    if [[ -z "${IMAGE_NAME:-}" ]]; then
        local project_folder_name
        project_folder_name=$(get_project_folder_name "$PROJECT_DIR" 2>/dev/null || echo "NONE")
        
        if [[ "$project_folder_name" == "NONE" ]]; then
            show_no_slots_menu  # This will exit
        fi
        
        IMAGE_NAME=$(get_image_name)
        PROJECT_SLOT_DIR="$PROJECT_PARENT_DIR/$project_folder_name"
        export PROJECT_SLOT_DIR
    fi
    
    # Check if image exists
    if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
        error "No Docker image found for this project.\nRun 'claudecircle' first to build the image."
    fi
    
    local persist_mode=false
    local shell_flags=()
    
    # Check if first arg is "admin"
    if [[ "${1:-}" == "admin" ]]; then
        persist_mode=true
        shift
        # In admin mode, automatically enable sudo and disable firewall
        shell_flags+=("--enable-sudo" "--disable-firewall")
    fi
    
    # Process remaining flags (only for non-persist mode)
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --enable-sudo|--disable-firewall)
                if [[ "$persist_mode" == "false" ]]; then
                    shell_flags+=("$1")
                fi
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    # Run container for shell
    if [[ "$persist_mode" == "true" ]]; then
        cecho "Administration Mode" "$YELLOW"
        echo "Sudo enabled, firewall disabled."
        echo "Changes will be saved to the image when you exit."
        echo
        
        # Create a named container for admin mode so we can commit it
        local temp_container="claudecircle-admin-$$"
        
        # Ensure cleanup runs on any exit (including Ctrl-C)
        cleanup_admin() {
            docker commit "$temp_container" "$IMAGE_NAME" >/dev/null 2>&1
            docker rm -f "$temp_container" >/dev/null 2>&1
        }
        trap cleanup_admin EXIT
        
        if [[ "$VERBOSE" == "true" ]]; then
            echo "[DEBUG] Running admin container with flags: ${shell_flags[*]}" >&2
            echo "[DEBUG] Remaining args after processing: $*" >&2
        fi
        # Don't pass any remaining arguments - only shell and the flags
        run_claudecircle_container "$temp_container" "interactive" shell "${shell_flags[@]}"
        
        # Commit changes back to image
        fillbar
        docker commit "$temp_container" "$IMAGE_NAME" >/dev/null
        docker rm -f "$temp_container" >/dev/null 2>&1
        fillbar stop
        success "Changes saved to image!"
    else
        # Regular shell mode - just run without committing
        run_claudecircle_container "" "interactive" shell "${shell_flags[@]}"
    fi
    
    exit 0
}

_cmd_update() {
    # Handle update all specially
    if [[ "${1:-}" == "all" ]]; then
        info "Updating all components..."
        echo
        
        # Update claudecircle script
        info "Updating claudecircle script..."
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL https://raw.githubusercontent.com/RchGrav/claudecircle/main/claudecircle -o /tmp/claudecircle.new
        elif command -v wget >/dev/null 2>&1; then
            wget -qO /tmp/claudecircle.new https://raw.githubusercontent.com/RchGrav/claudecircle/main/claudecircle
        else
            error "Neither curl nor wget found"
        fi
        
        if [[ -f /tmp/claudecircle.new ]]; then
            # Find the installed claudecircle (not the source)
            local installed_path=$(which claudecircle 2>/dev/null || echo "/usr/local/bin/claudecircle")
            
            # If it's a symlink, replace it with the actual file first
            if [[ -L "$installed_path" ]]; then
                info "Converting symlink to real file..."
                local source_file=$(readlink -f "$installed_path")
                if [[ -w "$(dirname "$installed_path")" ]]; then
                    cp "$source_file" "$installed_path.tmp"
                    mv "$installed_path.tmp" "$installed_path"
                    chmod +x "$installed_path"
                else
                    sudo cp "$source_file" "$installed_path.tmp"
                    sudo mv "$installed_path.tmp" "$installed_path"
                    sudo chmod +x "$installed_path"
                fi
            fi
            
            # Compare hashes of the INSTALLED file
            current_hash=$(crc32_file "$installed_path" || echo "none")
            new_hash=$(crc32_file /tmp/claudecircle.new)
            
            if [[ "$current_hash" != "$new_hash" ]]; then
                info "New version available, updating..."
                
                # Backup current installed version
                local backups_dir="$HOME/.claudecircle/backups"
                mkdir -p "$backups_dir"
                local timestamp=$(date +%s)
                cp "$installed_path" "$backups_dir/$timestamp"
                info "Backed up current version to $backups_dir/$timestamp"
                
                # Update the INSTALLED file
                if [[ -w "$installed_path" ]] || [[ -w "$(dirname "$installed_path")" ]]; then
                    cp /tmp/claudecircle.new "$installed_path"
                    chmod +x "$installed_path"
                else
                    sudo cp /tmp/claudecircle.new "$installed_path"
                    sudo chmod +x "$installed_path"
                fi
                success "✓ Claudecircle script updated at $installed_path"
            else
                success "✓ Claudecircle script already up to date"
            fi
            rm -f /tmp/claudecircle.new
        fi
        echo
        
        # Update commands
        info "Updating commands..."
        local commands_dir="$HOME/.claudecircle/commands"
        mkdir -p "$commands_dir"
        
        for cmd in taskengine devops; do
            echo -n "  Updating $cmd.md... "
            if command -v curl >/dev/null 2>&1; then
                curl -fsSL "https://raw.githubusercontent.com/RchGrav/claudecircle/main/commands/$cmd.md" -o "$commands_dir/$cmd.md"
            else
                wget -qO "$commands_dir/$cmd.md" "https://raw.githubusercontent.com/RchGrav/claudecircle/main/commands/$cmd.md"
            fi
            echo "✓"
        done
        echo
        
        # Now update Claude
        info "Updating Claude..."
        shift # Remove "update"
        shift # Remove "all"
        set -- "update" "$@" # Put back just "update"
    fi
    
    # Check if image exists first
    if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
        error "No Docker image found for this project folder: $PROJECT_DIR\nRun 'claudecircle' first to build the image, or cd to your project directory."
    fi
    
    # Continue with normal update flow
    _cmd_special "update" "$@"
}

export -f _cmd_help _cmd_shell _cmd_update