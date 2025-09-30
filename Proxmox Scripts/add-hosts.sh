#!/usr/bin/env bash
#
# add-hosts.sh - Append host entries to /etc/hosts interactively
# Usage:
#   curl -s https://raw.githubusercontent.com/<user>/<repo>/main/add-hosts.sh | bash
#

set -euo pipefail

HOSTS_FILE="/etc/hosts"

echo "🔧 Adding entries to $HOSTS_FILE"
echo "Enter host entries (format: IP hostname)."
echo "You can enter multiple lines. Press ENTER on an empty line to finish."
echo ""

TMPFILE=$(mktemp)

while true; do
    read -r line
    [[ -z "$line" ]] && break
    echo "$line" >> "$TMPFILE"
done

if [[ -s "$TMPFILE" ]]; then
    echo "" >> "$HOSTS_FILE"
    echo "# Added by add-hosts.sh on $(date)" >> "$HOSTS_FILE"
    cat "$TMPFILE" >> "$HOSTS_FILE"
    echo "✅ Entries added successfully."
else
    echo "⚠️ No entries provided. Nothing changed."
fi

rm -f "$TMPFILE"
