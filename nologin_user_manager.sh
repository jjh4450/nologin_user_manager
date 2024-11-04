#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run with root privileges."
        exit 1
    fi
}

check_user_exists() {
    if id "$1" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

validate_username() {
    local username="$1"
    if [[ ! "$username" =~ ^[a-zA-Z][a-zA-Z0-9_-]{2,31}$ ]]; then
        return 1
    fi
    return 0
}

add_user() {
    while true; do
        read -e -p "Enter username to add: " username
        
        if ! validate_username "$username"; then
            log_error "Invalid username format. Please follow these rules:"
            echo "- Must start with a letter"
            echo "- Can contain letters, numbers, hyphens(-), and underscores(_)"
            echo "- Length must be between 3-32 characters"
            continue
        fi
        
        if check_user_exists "$username"; then
            log_error "User $username already exists."
            continue
        fi
        
        break
    done
    
    if useradd -m -s /sbin/nologin "$username"; then
        log_info "User $username has been created."
        
        while true; do
            if passwd "$username"; then
                log_info "Password has been set successfully."
                break
            else
                log_error "Failed to set password. Please try again."
            fi
        done
    else
        log_error "Failed to create user."
    fi
}

list_nologin_users() {
    log_info "Users with '/sbin/nologin' shell:"
    echo "------------------------"
    if ! awk -F: '$7 == "/sbin/nologin" {printf "User: %-20s UID: %-6s GID: %-6s Home: %s\n", $1, $3, $4, $6}' /etc/passwd; then
        log_error "Error occurred while listing users."
    fi
    echo "------------------------"
}

delete_user() {
    while true; do
        read -e -p "Enter username to delete: " username
        
        if ! validate_username "$username"; then
            log_error "Invalid username format."
            continue
        fi
        
        if ! check_user_exists "$username"; then
            log_error "User $username does not exist."
            continue
        fi
        
        # Check if user has nologin shell
        if ! grep -q "^$username:.*:/sbin/nologin$" /etc/passwd; then
            log_error "User $username does not have /sbin/nologin shell."
            continue
        fi
        
        break
    done
    
    read -e -p "Delete home directory as well? (y/n): " del_home
    
    if [[ "$del_home" =~ ^[Yy]$ ]]; then
        if userdel -r "$username"; then
            log_info "User $username has been deleted along with their home directory."
        else
            log_error "Error occurred while deleting user."
        fi
    else
        if userdel "$username"; then
            log_info "User $username has been deleted."
        else
            log_error "Error occurred while deleting user."
        fi
    fi
}

main() {
    check_root
    
    while true; do
        echo -e "\nUser Management System"
        echo "1. Add user with /sbin/nologin shell"
        echo "2. List users with /sbin/nologin shell"
        echo "3. Delete user with /sbin/nologin shell"
        echo "0. Exit"
        
        read -e -p "Select an option (0-3): " choice
        echo
        
        case $choice in
            1) add_user ;;
            2) list_nologin_users ;;
            3) delete_user ;;
            0) log_info "Exiting program..."; exit 0 ;;
            *) log_error "Invalid option. Please try again." ;;
        esac
    done
}
main
