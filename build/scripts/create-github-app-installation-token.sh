#!/usr/bin/env bash
#
# Creates a short-lived GitHub App installation access token. The token is
# written only to stdout so callers can pass it directly to the release command
# without storing it as a pipeline variable.

set -euo pipefail

required_variables=(
  GITHUB_APP_ID
  GITHUB_APP_INSTALLATION_ID
  GITHUB_APP_PRIVATE_KEY_BASE64
)

for variable in "${required_variables[@]}"; do
  if [[ -z "${!variable:-}" ]]; then
    echo "${variable} must be set." >&2
    exit 1
  fi
done

if [[ ! "$GITHUB_APP_ID" =~ ^[0-9]+$ ]]; then
  echo "GITHUB_APP_ID must be numeric." >&2
  exit 1
fi

if [[ ! "$GITHUB_APP_INSTALLATION_ID" =~ ^[0-9]+$ ]]; then
  echo "GITHUB_APP_INSTALLATION_ID must be numeric." >&2
  exit 1
fi

private_key_file="$(mktemp)"
trap 'rm -f "$private_key_file"' EXIT
chmod 600 "$private_key_file"

if ! printf '%s' "$GITHUB_APP_PRIVATE_KEY_BASE64" | base64 --decode >"$private_key_file"; then
  echo "GITHUB_APP_PRIVATE_KEY_BASE64 must be a valid base64-encoded private key." >&2
  exit 1
fi

if ! openssl pkey -in "$private_key_file" -noout >/dev/null 2>&1; then
  echo "GITHUB_APP_PRIVATE_KEY_BASE64 does not contain a valid private key." >&2
  exit 1
fi

base64url() {
  openssl base64 -A | tr '+/' '-_' | tr -d '='
}

issued_at="$(date +%s)"
expires_at="$((issued_at + 540))"
header="$(printf '%s' '{"alg":"RS256","typ":"JWT"}' | base64url)"
payload="$(printf '{"iat":%s,"exp":%s,"iss":"%s"}' "$issued_at" "$expires_at" "$GITHUB_APP_ID" | base64url)"
signing_input="${header}.${payload}"
signature="$(printf '%s' "$signing_input" | openssl dgst -sha256 -sign "$private_key_file" | base64url)"
app_jwt="${signing_input}.${signature}"

access_token="$({
  curl --fail --silent --show-error \
    --request POST \
    --header 'Accept: application/vnd.github+json' \
    --header 'X-GitHub-Api-Version: 2022-11-28' \
    --header "Authorization: Bearer ${app_jwt}" \
    "https://api.github.com/app/installations/${GITHUB_APP_INSTALLATION_ID}/access_tokens" \
    | python3 -c '
import json
import sys

response = json.load(sys.stdin)
token = response.get("token")
if not isinstance(token, str) or not token:
    raise SystemExit("GitHub token exchange response lacked a token.")
print(token, end="")
'
} )"

printf '%s\n' "$access_token"
