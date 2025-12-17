#!/usr/bin/env zsh
# ============================================================================
# MOTD (Message of the Day) - Dynamic System Info
# ============================================================================
# Displays system information on shell startup
#
# Functions:
#   show_motd       - Compact box format
#   show_motd_mini  - Single line format
# ============================================================================

# Only run in interactive shells
[[ -o interactive ]] || return 0

# ============================================================================
# Colors (ANSI escape codes)
# ============================================================================

_M_RESET=$'\033[0m'
_M_BOLD=$'\033[1m'
_M_DIM=$'\033[2m'
_M_BLUE=$'\033[38;5;39m'
_M_CYAN=$'\033[38;5;51m'
_M_GREEN=$'\033[38;5;82m'
_M_YELLOW=$'\033[38;5;220m'
_M_GREY=$'\033[38;5;242m'

# ============================================================================
# Info Gathering
# ============================================================================

_motd_uptime() {
    local up=$(uptime 2>/dev/null)
    if [[ "$up" =~ "up "([^,]+) ]]; then
        echo "${match[1]}" | sed 's/^ *//'
    else
        echo "?"
    fi
}

_motd_load() {
    if [[ -f /proc/loadavg ]]; then
        awk '{print $1}' /proc/loadavg
    else
        uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | xargs
    fi
}

_motd_mem() {
    free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}' || echo "N/A"
}

_motd_disk() {
    df -h / 2>/dev/null | awk 'NR==2 {print $4 " free"}' || echo "N/A"
}

# ============================================================================
# String Length (excluding ANSI codes)
# ============================================================================

_motd_strlen() {
    # Remove ANSI escape codes and count actual visible characters
    local str="$1"
    # Remove all ANSI escape sequences
    str="${str//$'\033'\[*([0-9;])m/}"
    echo "${#str}"
}

# ============================================================================
# Box Drawing - Fixed Width
# ============================================================================

# Fixed box width (total including borders)
_M_BOX_WIDTH=62
_M_CONTENT_WIDTH=$((_M_BOX_WIDTH - 4))  # Account for "│ " and " │"

_motd_line() {
    local char="$1"
    local width="${2:-$_M_BOX_WIDTH}"
    printf "%${width}s" | tr ' ' "$char"
}

_motd_pad_line() {
    # Pad content to exact width, accounting for ANSI codes
    local content="$1"
    local target_width="$2"
    
    # Calculate actual visible length
    local visible_len=$(_motd_strlen "$content")
    local padding=$((target_width - visible_len))
    
    if (( padding > 0 )); then
        printf "%s%${padding}s" "$content" ""
    else
        echo "$content"
    fi
}

# ============================================================================
# Main Display Function
# ============================================================================

show_motd() {
    [[ -n "$_MOTD_SHOWN" && "$1" != "--force" ]] && return 0
    typeset -g _MOTD_SHOWN=1

    local hostname="${HOST:-$(hostname -s 2>/dev/null)}"
    local datetime=$(date '+%a %b %d %H:%M')
    local uptime=$(_motd_uptime)
    local load=$(_motd_load)
    local mem=$(_motd_mem)
    local disk=$(_motd_disk)

    # Build lines
    local hline=$(_motd_line '─' $((_M_BOX_WIDTH - 2)))
    
    echo ""
    
    # Top border
    echo "${_M_GREY}┌${hline}┐${_M_RESET}"
    
    # Header line: "✦ hostname" + spaces + "datetime"
    local header_content="${_M_BOLD}${_M_BLUE}✦${_M_RESET} ${_M_BOLD}${hostname}${_M_RESET}"
    local header_right="${_M_DIM}${datetime}${_M_RESET}"
    
    # Calculate padding needed
    local header_left_visible=$(_motd_strlen "✦ ${hostname}")
    local header_right_visible=$(_motd_strlen "${datetime}")
    local header_padding=$((_M_CONTENT_WIDTH - header_left_visible - header_right_visible))
    
    printf "${_M_GREY}│${_M_RESET} %s%${header_padding}s%s ${_M_GREY}│${_M_RESET}\n" \
        "$header_content" "" "$header_right"
    
    # Separator
    echo "${_M_GREY}├${hline}┤${_M_RESET}"
    
    # Stats line: "▲ up:1d 23h  ◆ load:2%  ◇ mem:9.3G/23G  ⊡ 845G free"
    local stats_content="${_M_DIM}▲${_M_RESET} up:${uptime}  ${_M_DIM}◆${_M_RESET} load:${load}  ${_M_DIM}◇${_M_RESET} mem:${mem}  ${_M_DIM}⊡${_M_RESET} ${disk}"
    
    # Calculate visible length and padding
    local stats_visible=$(_motd_strlen "▲ up:${uptime}  ◆ load:${load}  ◇ mem:${mem}  ⊡ ${disk}")
    local stats_padding=$((_M_CONTENT_WIDTH - stats_visible))
    
    printf "${_M_GREY}│${_M_RESET} %s%${stats_padding}s ${_M_GREY}│${_M_RESET}\n" \
        "$stats_content" ""
    
    # Bottom border
    echo "${_M_GREY}└${hline}┘${_M_RESET}"
    
    echo ""
}

# ============================================================================
# Mini Format (Single Line)
# ============================================================================

show_motd_mini() {
    [[ -n "$_MOTD_SHOWN" && "$1" != "--force" ]] && return 0
    typeset -g _MOTD_SHOWN=1

    local hostname="${HOST:-$(hostname -s 2>/dev/null)}"
    local uptime=$(_motd_uptime)
    local mem=$(_motd_mem)

    echo "${_M_DIM}──${_M_RESET} ${_M_BOLD}${hostname}${_M_RESET} ${_M_DIM}│${_M_RESET} up:${uptime} ${_M_DIM}│${_M_RESET} mem:${mem} ${_M_DIM}──${_M_RESET}"
}

# ============================================================================
# Aliases
# ============================================================================

alias motd='show_motd --force'
alias motd-mini='show_motd_mini --force'
