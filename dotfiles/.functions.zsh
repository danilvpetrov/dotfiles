function git-slug () {
  if ! URL="$(git config --get remote.origin.url)"; then
    return 1
  fi

  if [[ "$URL" =~ [:/]([^/:]+/[^/]+)\.git$ ]]; then
    echo "${match[1]}"
  elif [[ "$1" == '--fuzzy' ]]; then
    echo "???/$(basename "$(pwd)")"
  else
    return 1
  fi
}

function source-if-exists () {
  [ -f "$1" ] && source "$1"
}

function iterm2_print_user_vars () {
  iterm2_set_user_var gitSlug "$(git-slug)"
}

function gosrcfind () {
  grep --color=always -iIRn "$1" "$(go env GOROOT)"
}

function cwd () {
  pwd | tr -d '\n' | pbcopy
}

function op_download_document() {
  local iinfo=$(op get item --account=my "$1" | jq '{uuid: (.uuid), vuuid: (.vaultUuid)}')
  op get document --account=my \
    $(echo $iinfo | jq --raw-output '.uuid') \
    $(echo $iinfo | jq --raw-output '.vuuid') \
    > "$2"
  chmod $3 "$2"
}

function op_get_password() {
  echo $(op get item --account=my "$1" | jq --raw-output '.details.password')
}
