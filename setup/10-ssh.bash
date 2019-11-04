set -e

if [ -f "$HOME/.ssh/id_rsa" ]; then
  echo "SSH key already exists."
else
  echo "Fetching SSH key from 1Password..."

  mkdir -p "$HOME/.ssh"
  op_download_document "id_rsa" "$HOME/.ssh/id_rsa" 0600
fi

echo "Adding SSH key to keychain..."

ssh-add -K "$HOME/.ssh/id_rsa"

# generate public key if it does not exist
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
  echo "SSH public key already exists."
else
  ssh-keygen -y -f "$HOME/.ssh/id_rsa" > "$HOME/.ssh/id_rsa.pub"
  chmod 0644 "$HOME/.ssh/id_rsa.pub"
fi

# add github.com to knowns hosts
ssh-keyscan -H github.com >> "$HOME/.ssh/known_hosts"

echo "Switching dotfiles repo to SSH..."

pushd "$HOME/dotfiles" > /dev/null
git remote set-url origin "$(git config --get remote.origin.url | sed 's/https:\/\/github.com\//git@github.com:/')"
popd > /dev/null
