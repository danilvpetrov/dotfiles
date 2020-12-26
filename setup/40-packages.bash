set -e

echo "Installing packages..."

# install pygments.rb and travis without failing
gem install --user-install \
  pygments.rb \
  travis || true

# install whatever we can without failing.
brew bundle "--file={{ .chezmoi.sourceDir }}/Brewfile" || true
# link MySQL client without failing.
brew link --force mysql-client || true
