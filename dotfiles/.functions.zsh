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

function op_check_session(){
  # attempt sign in if session is not active
  if ! op get account &> /dev/null; then
      op_signin
      op_check_session
  fi
}

function op_signin() {
    while [ -z "$OP_EMAIL" ]; do
        echo -n "1Password email address: "
        read OP_EMAIL
    done

    while [ -z "$OP_KEY" ]; do
        echo -n "1Password secret key: "
        read OP_KEY
    done

    eval $(op signin my "$OP_EMAIL" "$OP_KEY")
}



function op_download_document() {
  # make sure the user is signed in
  op_check_session

  local i=$(op get item --account=my "$1" | jq '{uuid: (.uuid), vuuid: (.vaultUuid)}')
  op get document --account=my \
    $(echo $i | jq --raw-output '.uuid') \
    $(echo $i | jq --raw-output '.vuuid') \
    > "$2"
  chmod $3 "$2"
}

function op_get_password() {
  # make sure the user is signed in
  op_check_session

  echo $(op get item --account=my "$1" | jq --raw-output '.details.password')
}

function op_get_login_username() {
  # make sure the user is signed in
  op_check_session

  echo $(op get item --account=my "$1" | jq --raw-output '.details.fields[]? | select(.designation == "username") | .value')
}

function op_get_login_password() {
  # make sure the user is signed in
  op_check_session

  echo $(op get item --account=my "$1" | jq --raw-output '.details.fields[]? | select(.designation == "password") | .value')
}

function winkbr() {
  # see this for reference: https://developer.apple.com/library/archive/technotes/tn2450/_index.html
  # 1. assign capslock to escape key
  # 2. swap right control and right alt
  # 3. swap left gui with left alt
  hidutil property --set '{"UserKeyMapping":
    [
      {"HIDKeyboardModifierMappingSrc":0x700000039,
        "HIDKeyboardModifierMappingDst":0x700000029},
      {"HIDKeyboardModifierMappingSrc":0x7000000e6,
        "HIDKeyboardModifierMappingDst":0x7000000e4},
      {"HIDKeyboardModifierMappingSrc":0x7000000e4,
        "HIDKeyboardModifierMappingDst":0x7000000e6},
      {"HIDKeyboardModifierMappingSrc":0x7000000E2,
        "HIDKeyboardModifierMappingDst":0x7000000E3},
         {"HIDKeyboardModifierMappingSrc":0x7000000E3,
        "HIDKeyboardModifierMappingDst":0x7000000E2}
    ]
  }'
}

function resetkbr() {
  # reset all user key mappings
  hidutil property --set '{"UserKeyMapping":[]}'
}
