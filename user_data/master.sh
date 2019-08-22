#!/usr/bin/env bash

# Without $HOME, a message is seen in cloud-init-output.log during autosign:
#   couldn't find login name -- expanding `~'
export HOME='/root'

configure_ssh() {
  sed -i '
    s/.*PermitRootLogin.*/PermitRootLogin without-password/
    ' /etc/ssh/sshd_config
  systemctl restart sshd
  mkdir -p -m 700 /root/.ssh
  cat > /root/.ssh/authorized_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZWI7KSYD2tR0k+oxUsoY/DCVzryyH1z2i01Bx+pVY1/hPNwgrLFKYJVGqQyOtXNn0UqLr5DRwii8OYZsqccs7LPSZPgIJzTQpHtqudPJ3eB4EhU0NNdjKcgvZcBPnJBu9tKHKo8pB7sEkcCcXIfjrQcOJk0Ljyqn1mRzT37Q7mouNWd4aQKq8Pdq+r9IYe4Rhi5Avgxd04lZ3hbojcTPxNyxL+6kQZ0plnt09drNOomirW2MkOeKN+ySNlYskhB/Xag/J6FVAcMMcKo3quVRvYEFi8Z/rt5AnO345ZLwVIGIGwcj3Tx7wAjEUdK/N9y7uv757pw0YMPrcNTZ+C/n5 puppet
EOF
  chmod 644 /root/.ssh/authorized_keys
}

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
  puppetserver ca setup
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
  configure_ssh
  install_puppetserver
  configure_puppetserver
  configure_autosign
  deploy_code
}

main

# vim: set ft=sh: