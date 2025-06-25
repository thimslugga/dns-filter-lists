#!/bin/bash
set -euo pipefail

readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_VERSION="0.1.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

readonly URL="https://support.apple.com/en-us/HT210060"
readonly OUTPUT_FILE="apple-enterprise-domains.txt"
readonly OUTPUT_DIR="${PROJECT_ROOT}/out"
readonly OUTPUT_PATH="${OUTPUT_DIR}/${OUTPUT_FILE}"

# Colors
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_RESET='\033[0m'

# Excluded domains
readonly EXCLUDES=(
  "ogp.me"
  "schema.org"
  "www.w3.org"
)

# Logging functions
function log() {
  local level="$1"
  shift
  local datetime
  datetime="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${datetime} [${level}] $*" >&2
}

function info() {
  log "INFO" "$@"
}

function error() {
  log "ERROR" "$@"
}

function warn() {
  log "WARN" "$@"
}

# Cleanup function
function cleanup() {
  local exit_code="$?"
  if [[ -n "${TEMP_DIR:-}" && -d "${TEMP_DIR}" ]]; then
    info "Clean up temporary directory: ${TEMP_DIR}"
    rm -rf "${TEMP_DIR}"
  fi

  exit "${exit_code}"
}

# Check for required dependencies
function dependency_check() {
  local required_commands=("curl" "grep" "sort")
  local missing_deps=()

  for cmd in "${required_commands[@]}"; do
    if ! command -v "${cmd}" > /dev/null 2>&1; then
      missing_deps+=("${cmd}")
    fi
  done

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing_deps[*]}"
    exit 1
  fi
}

# Check whether the URL is reachable
function is_url_reachable() {
  if ! curl -s -I -X HEAD --max-time 30 "${URL}" | grep -q "200 OK"; then
    error "Unable to reach URL or there was non-200 status: ${URL}"
    return 1
  fi
}

function fetch_content() {
  info "Fetch content from URL: ${URL}"

  local content
  if ! content="$(curl -sL --max-time 60 "${URL}")"; then
    error "Failure to fetch web content from URL: ${URL}"
    return 1
  fi

  echo "${content}"
}

function parse_domains() {
  local content="$1"

  local domains
  domains=$(echo "${content}" \
    | grep -oP '(?<=://)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' \
    | grep -v '^[0-9.]*$' \
    | sort -u)

  if [[ -z "${domains}" ]]; then
    warn "Unable to find any domains the fetched web page content from URL: ${URL}"
    return 1
  fi

  local domain_count
  domain_count=$(echo "${domains}" | wc -l)

  info "Unique domains found: ${domain_count}"

  echo "${domains}"
}

function write_output_file() {
  local domains="$1"

  if [[ ! -d "${OUTPUT_DIR}" ]]; then
    #info "Create output directory: ${OUTPUT_DIR}"
    mkdir -p "${OUTPUT_DIR}"
  fi

  # Create header for the file
  {
    echo "# Apple Enterprise Domains List"
    echo ""
    echo "# Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "# Generated from URL: ${URL}"
    echo "# Total domains: $(echo "${domains}" | wc -l)"
    echo "#"
    echo "${domains}"
  } > "${OUTPUT_PATH}"

  info "Successfully wrote discovered domains to file: ${OUTPUT_PATH}"
}

function main() {
  # Set up cleanup trap
  trap cleanup EXIT ERR

  info "Create Apple enterprise domains list file."

  TEMP_DIR="$(mktemp -d)"

  dependency_check

  is_url_reachable

  # Fetch content and parse domains
  local content
  content=$(fetch_content)

  local domains
  domains=$(parse_domains "${content}")

  write_output_file "${domains}"

  info "Done."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
