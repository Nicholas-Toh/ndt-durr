#!/bin/bash

cd /var/app/current

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash

# Source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install node
nvm install 16

nvm alias default 16

ln -sf  $(nvm which 16) /usr/bin/node

npm i && npm run build