#!/bin/bash

set -o nounset

HOSTNAME=$(hostname -s)
CUSTOM_WHITELIST=""

# parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --hostname)
            [[ $# -ge 2 ]] || {
                echo "ERROR: Missing hostname argument"
                exit 2
            }
            HOSTNAME="$2"
            shift 2
            ;;

        --help|-h)
            echo "Usage: $0 [--hostname HOSTNAME] [WHITELIST_FILE]"
            exit 0
            ;;
        -*)
            echo "ERROR: Unknown option: $1"
            exit 2
            ;;
        
        *)
            if [[ -n "$CUSTOM_WHITELIST" ]]; then
                echo "ERROR: Multiple whitelist files are not supported."
                exit 2
            fi

            CUSTOM_WHITELIST="$1"
            shift
            ;;
    esac
done

# list of whitelisted services
case "$HOSTNAME" in 

    pitlane)
        WHITELIST=(
            
        )
        ;;

    garage)
        WHITELIST=(
            
        )
        ;;
    
    grandstand)
        WHITELIST=(
            
        )
        ;;

    scrutineering)
        WHITELIST=(
            
        )
        ;;

    *)
        echo "ERROR: No whitelist defined for hostname: $HOSTNAME"
        exit 2
        ;;

esac

# load whitelist file if provided
if [[ -n "$CUSTOM_WHITELIST" ]]; then
    if [[ ! -f "$CUSTOM_WHITELIST" || ! -r "$CUSTOM_WHITELIST" ]]; then
        echo "ERROR: Cannot read whitelist file: $CUSTOM_WHITELIST"
        exit 2
    fi

    while IFS= read -r service || [[ -n "$service" ]]; do
        [[ -z "$service" || "$service" =~ ^[[:space:]]*# ]] && continue

        service="${service#"${service%%[![:space:]]*}"}"
        service="${service%"${service##*[![:space:]]}"}"

        service="${service%.service}"

        if [[ ! "$service" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
            echo "ERROR: Invalid service in whitelist: $service"
            exit 2
        fi

        WHITELIST+=("$service")
    
    done < "$CUSTOM_WHITELIST"
fi

# whitelist lookup
declare -A ALLOWED_SERVICES

for service in "${WHITELIST[@]}"; do
    service="${service%.service}"
    ALLOWED_SERVICES["$service"]=1
done

# fetch all enabled system services from systemctl
UNKNOWN_SERVICES=()

while IFS= read -r service; do
    service="${service%.service}"

    [[ -z "$service" ]] && continue

    if [[ -z "${ALLOWED_SERVICES[$service]+x}" ]]; then
        UNKNOWN_SERVICES+=("$service")
    fi

done < <(
    systemctl list-unit-files \
        --type=service \
        --state=enabled \
        --no-legend \
        --no-pager |
    awk '{print $1}'
)

# report findings
if [[ ${#UNKNOWN_SERVICES[@]} -eq 0 ]]; then
    echo "All services whitelisted for $HOSTNAME."
    exit 0
else
    echo "Found ${#UNKNOWN_SERVICES[@]} non-whitelisted services:"
    echo

    for service in "${UNKNOWN_SERVICES[@]}"; do
        echo "  $service"
        done

    exit 1
fi