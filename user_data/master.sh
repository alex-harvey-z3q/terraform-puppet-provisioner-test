#!/usr/bin/env bash

# Without $HOME, a message is seen in cloud-init-output.log during autosign:
#   couldn't find login name -- expanding `~'
export HOME='/root'

install_puppetserver() {
  wget https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
  rpm -Uvh puppet6-release-el-7.noarch.rpm
  yum-config-manager --enable puppet6
  yum -y install puppetserver
}

configure_puppetserver() {
  echo 'export PATH=/opt/puppetlabs/puppet/bin:$PATH' \
    >> /etc/profile.d/puppet-agent.sh
  . /etc/profile.d/puppet-agent.sh
  sed -i '
    s/JAVA_ARGS.*/JAVA_ARGS="-Xms512m -Xmx512m"/
    ' /etc/sysconfig/puppetserver # workaround for t2.micro's 1GB RAM.
  local public_hostname=$(curl \
    http://169.254.169.254/latest/meta-data/public-hostname)
  puppetserver ca setup \
    --subject-alt-names "$public_hostname",localhost,puppet
  echo "127.0.0.1  puppet" >> /etc/hosts
}

configure_autosign() {
  gem install autosign
  mkdir -p -m 750 /var/autosign
  chown puppet: /var/autosign
  touch /var/log/autosign.log
  chown puppet: /var/log/autosign.log
  autosign config setup
  sed -i '
    s!journalfile:.*!journalfile: "/var/autosign/autosign.journal"!
    ' /etc/autosign.conf
  puppet config set \
    --section master autosign /opt/puppetlabs/puppet/bin/autosign-validator
  systemctl restart puppetserver
}

deploy_code() {
  yum -y install git
  rm -rf /etc/puppetlabs/code/environments/production
  git clone \
    https://github.com/alexharv074/terraform-puppet-provisioner-test.git \
    /etc/puppetlabs/code/environments/production
}

main() {
  install_puppetserver
  configure_puppetserver
  configure_autosign
  deploy_code
}

main

# vim: set ft=sh:
