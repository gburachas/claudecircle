#!/usr/bin/env bash
# Compose commands for multi-agent orchestration

# Global compose directory
COMPOSE_DIR="${SCRIPT_DIR}/compose"

# Run docker-compose with project context
_compose_exec() {
    local compose_file="$COMPOSE_DIR/docker-compose.yml"
    
    if [[ ! -f "$compose_file" ]]; then
        error "Compose file not found: $compose_file"
    fi
    
    # Set environment variables for compose
    export PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
    export PROJECT_NAME="${PROJECT_NAME:-$(basename "$PROJECT_DIR")}"
    
    docker compose -f "$compose_file" "$@"
}

# Initialize compose configuration
_cmd_compose_init() {
    info "Initializing multi-agent compose configuration..."
    
    # Ensure network exists
    ensure_claudecircle_network
    
    # Create domain data directories
    local domains=("dev" "marketing" "ops" "cxo")
    for domain in "${domains[@]}"; do
        mkdir -p "$HOME/.claudecircle/$domain"
    done
    
    # Create blackboard directory
    mkdir -p "$PROJECT_DIR/.claude/blackboard"
    
    success "Multi-agent compose initialized!"
    echo
    echo "Usage:"
    echo "  claudecircle compose up [domains...]    Start containers"
    echo "  claudecircle compose down               Stop all containers"
    echo "  claudecircle compose status             Show container status"
    echo "  claudecircle compose logs [domain]      View logs"
}

# Start containers
_cmd_compose_up() {
    local profiles=()
    
    if [[ $# -eq 0 ]]; then
        # Default to all domains
        profiles=(--profile all)
    else
        # Use specified domains
        for domain in "$@"; do
            profiles+=(--profile "$domain")
        done
    fi
    
    info "Starting multi-agent containers..."
    ensure_claudecircle_network
    _compose_exec "${profiles[@]}" up -d
    
    success "Containers started!"
    _cmd_compose_status
}

# Stop containers
_cmd_compose_down() {
    info "Stopping multi-agent containers..."
    _compose_exec --profile all down
    success "Containers stopped."
}

# Show status
_cmd_compose_status() {
    echo
    cecho "Multi-Agent Container Status" "$CYAN"
    echo
    _compose_exec ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    echo
    
    # Network info
    cecho "Network: $CLAUDECIRCLE_NETWORK" "$DIM"
    docker network inspect "$CLAUDECIRCLE_NETWORK" --format '{{range .Containers}}  - {{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' 2>/dev/null || true
}

# View logs
_cmd_compose_logs() {
    local domain="${1:-}"
    
    if [[ -n "$domain" ]]; then
        _compose_exec logs -f "$domain"
    else
        _compose_exec logs -f
    fi
}

# Main compose command dispatcher
_cmd_compose() {
    local subcmd="${1:-}"
    shift || true
    
    case "$subcmd" in
        init)   _cmd_compose_init "$@" ;;
        up)     _cmd_compose_up "$@" ;;
        down)   _cmd_compose_down "$@" ;;
        status) _cmd_compose_status "$@" ;;
        logs)   _cmd_compose_logs "$@" ;;
        ""|help)
            echo "Multi-Agent Docker Compose Commands"
            echo
            echo "Usage: claudecircle compose <command> [options]"
            echo
            echo "Commands:"
            echo "  init              Initialize compose configuration"
            echo "  up [domains...]   Start containers (dev, marketing, ops, cxo)"
            echo "  down              Stop all containers"
            echo "  status            Show container status"
            echo "  logs [domain]     View container logs"
            ;;
        *)
            error "Unknown compose command: $subcmd"
            ;;
    esac
}

export -f _cmd_compose _compose_exec _cmd_compose_init _cmd_compose_up _cmd_compose_down _cmd_compose_status _cmd_compose_logs
