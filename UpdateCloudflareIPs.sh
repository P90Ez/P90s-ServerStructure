#!/bin/bash
set -e

# figure out where the server structure directory lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/" && pwd)"

OUTPUT="$BASE_DIR/Configs/nginx/includes/cloudflare-allow.conf"
TMP_FILE=$(mktemp)

# get ip ranges from cloudflare
IPS_V4="$(curl -fsS https://www.cloudflare.com/ips-v4)"
IPS_V6="$(curl -fsS https://www.cloudflare.com/ips-v6)"

echo "# cron generated cloudflare allow list - UpdateCloudflareIPs.sh" > "$TMP_FILE"
echo "# last updated: $(date)" >> "$TMP_FILE"
echo "" >> "$TMP_FILE"

# ipv4
echo "# ipv4" >> "$TMP_FILE"
echo "$IPS_V4" | sed 's/^/allow /; s/$/;/' >> "$TMP_FILE"
echo "$IPS_V4" | sed 's/^/set_real_ip_from /; s/$/;/' >>  "$TMP_FILE"
echo "" >> "$TMP_FILE"

# ipv6
echo "# ipv6" >> "$TMP_FILE"
echo "$IPS_V6" | sed 's/^/allow /; s/$/;/' >> "$TMP_FILE"
echo "$IPS_V6" | sed 's/^/set_real_ip_from /; s/$/;/' >>  "$TMP_FILE"
echo "" >> "$TMP_FILE"

mv "$TMP_FILE" "$OUTPUT"
echo "Cloudflare IP list updated"

# test config and reload
docker exec nginx nginx -t && docker exec nginx nginx -s reload