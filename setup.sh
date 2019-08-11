#!/usr/bin/env bash

brew cask install puppetlabs/puppet/puppet-bolt

mkdir -p ~/.puppetlabs/bolt/

cp \
  inventory.yaml \
  bolt.yaml \
  Puppetfile \
  ~/.puppetlabs/bolt/

bolt puppetfile install
