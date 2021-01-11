set -e

SECURE_PATH="$HOME/.zshenv.secure"

function update-token () {
  NAME="$1"
  VALUE="$2"

  PREFIX="^export $NAME"
  REPLACEMENT="export $NAME="'"'"$VALUE"'"'

  grep -q "$PREFIX" "$SECURE_PATH" && sed -i "" "s/$PREFIX.*/$REPLACEMENT/" "$SECURE_PATH" || echo "$REPLACEMENT" >> "$SECURE_PATH"
  sort -o "$SECURE_PATH" "$SECURE_PATH"
}

echo "Fetching GitHub token from 1Password..."

export GITHUB_TOKEN="$(op get item "Github Token" | jq -r '.details.password')"
export HOMEBREW_GITHUB_API_TOKEN="$GITHUB_TOKEN"

update-token "GITHUB_TOKEN" "$GITHUB_TOKEN"
