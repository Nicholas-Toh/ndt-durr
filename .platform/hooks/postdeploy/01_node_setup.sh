#!/bin/bash

cd /var/app/current

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash

sudo yum remove -y nodejs npm

sudo rm -fr /var/cache/yum/*

sudo yum clean all

curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -

sudo yum install nodejs -y
npm i && npm run build