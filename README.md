# Terraform Puppet Provisioner Test

## Overview

This is a proof of concept of the Puppet Terraform provisioner that was added in Terraform 0.12.2. It uses Terraform and the Terraform Puppet provisioner to set up a Puppet Master and two Agents, one that uses the latest Amazon Linux 2 AMI and another that uses Windows 2016, and then installs a very simple "hello world" Puppet module on the Puppet Master, and then configures the agent node using this code.

It assumes you will use Mac OS X on your laptop. Minor changes would be required otherwise.

## Architecture

The following figure shows the main components of the solution:

![Fig 1](./arch.jpg)

## Dependencies

Install the latest Terraform (>= 0.12.2). Get that from [here](https://www.terraform.io/downloads.html).

Puppet Bolt is also required, but the setup.sh script will install it if it's not there.

Note also that, at the time of writing, the project depends on an [unmerged](https://github.com/puppetlabs/puppetlabs-puppet_agent/pull/444) pull request I've raised against the [puppetlabs-puppet_agent](https://github.com/puppetlabs/puppetlabs-puppet_agent) project to add Amazon Linux 2 support. This is branch is referenced in the [Puppetfile](./bolt/Puppetfile) so again no need to do anything yet.

There is also an assumption that you will provide an EC2 key pair and it will have the name "default". If that's not there, create the EC2 Key Pair using:

```text
▶ aws ec2 create-key-pair --key-name default
```

## Usage

### Setup script

First run the setup script.

```text
▶ bash -x setup.sh
```

This will:

- If necessary, install the latest Puppet Bolt as a Brew Cask.
- Make the Bolt Config directory.
- Install the required Bolt modules (`bolt puppetfile install`).

See the code [here](./setup.sh).

### Apply terraform

Then run terraform apply:

```text
▶ terraform init
▶ terraform apply -auto-approve
```

### Expected output

```text
▶ terraform apply -auto-approve
data.template_file.winrm: Refreshing state...
data.template_file.user_data: Refreshing state...
data.aws_ami.ami: Refreshing state...
data.aws_ami.windows_2012R2: Refreshing state...
aws_instance.master: Creating...
aws_instance.master: Still creating... [10s elapsed]
aws_instance.master: Still creating... [20s elapsed]
aws_instance.master: Still creating... [30s elapsed]
aws_instance.master: Provisioning with 'remote-exec'...
aws_instance.master (remote-exec): Connecting to remote host via SSH...
aws_instance.master (remote-exec):   Host: 13.239.139.194
aws_instance.master (remote-exec):   User: ec2-user
aws_instance.master (remote-exec):   Password: false
aws_instance.master (remote-exec):   Private key: true
aws_instance.master (remote-exec):   Certificate: false
aws_instance.master (remote-exec):   SSH Agent: true
aws_instance.master (remote-exec):   Checking Host Key: false
aws_instance.master: Still creating... [40s elapsed]
aws_instance.master (remote-exec): Connecting to remote host via SSH...
aws_instance.master (remote-exec):   Host: 13.239.139.194
aws_instance.master (remote-exec):   User: ec2-user
aws_instance.master (remote-exec):   Password: false
aws_instance.master (remote-exec):   Private key: true
aws_instance.master (remote-exec):   Certificate: false
aws_instance.master (remote-exec):   SSH Agent: true
aws_instance.master (remote-exec):   Checking Host Key: false
aws_instance.master: Still creating... [50s elapsed]
aws_instance.master: Still creating... [1m0s elapsed]
aws_instance.master (remote-exec): Connecting to remote host via SSH...
aws_instance.master (remote-exec):   Host: 13.239.139.194
aws_instance.master (remote-exec):   User: ec2-user
aws_instance.master (remote-exec):   Password: false
aws_instance.master (remote-exec):   Private key: true
aws_instance.master (remote-exec):   Certificate: false
aws_instance.master (remote-exec):   SSH Agent: true
aws_instance.master (remote-exec):   Checking Host Key: false
aws_instance.master (remote-exec): Connecting to remote host via SSH...
aws_instance.master (remote-exec):   Host: 13.239.139.194
aws_instance.master (remote-exec):   User: ec2-user
aws_instance.master (remote-exec):   Password: false
aws_instance.master (remote-exec):   Private key: true
aws_instance.master (remote-exec):   Certificate: false
aws_instance.master (remote-exec):   SSH Agent: true
aws_instance.master (remote-exec):   Checking Host Key: false
aws_instance.master (remote-exec): Connected!
aws_instance.master: Still creating... [1m10s elapsed]
aws_instance.master: Still creating... [1m20s elapsed]
aws_instance.master: Still creating... [1m30s elapsed]
aws_instance.master: Still creating... [1m40s elapsed]
aws_instance.master: Still creating... [1m50s elapsed]
aws_instance.master: Still creating... [2m0s elapsed]
aws_instance.master: Still creating... [2m10s elapsed]
aws_instance.master: Still creating... [2m20s elapsed]
aws_instance.master: Still creating... [2m30s elapsed]
aws_instance.master: Still creating... [2m40s elapsed]
aws_instance.master: Still creating... [2m50s elapsed]
aws_instance.master: Still creating... [3m0s elapsed]
aws_instance.master: Still creating... [3m10s elapsed]
aws_instance.master: Creation complete after 3m17s [id=i-0d126b0f634539c45]
aws_instance.linux_agent: Creating...
aws_instance.win_agent: Creating...
aws_instance.win_agent: Still creating... [10s elapsed]
aws_instance.linux_agent: Still creating... [10s elapsed]
aws_instance.linux_agent: Still creating... [20s elapsed]
aws_instance.win_agent: Still creating... [20s elapsed]
aws_instance.linux_agent: Provisioning with 'puppet'...
aws_instance.linux_agent (puppet): Connecting to remote host via SSH...
aws_instance.linux_agent (puppet):   Host: 54.252.134.38
aws_instance.linux_agent (puppet):   User: ec2-user
aws_instance.linux_agent (puppet):   Password: false
aws_instance.linux_agent (puppet):   Private key: true
aws_instance.linux_agent (puppet):   Certificate: false
aws_instance.linux_agent (puppet):   SSH Agent: true
aws_instance.linux_agent (puppet):   Checking Host Key: false
aws_instance.win_agent: Still creating... [30s elapsed]
aws_instance.linux_agent: Still creating... [30s elapsed]
aws_instance.linux_agent (puppet): Connecting to remote host via SSH...
aws_instance.linux_agent (puppet):   Host: 54.252.134.38
aws_instance.linux_agent (puppet):   User: ec2-user
aws_instance.linux_agent (puppet):   Password: false
aws_instance.linux_agent (puppet):   Private key: true
aws_instance.linux_agent (puppet):   Certificate: false
aws_instance.linux_agent (puppet):   SSH Agent: true
aws_instance.linux_agent (puppet):   Checking Host Key: false
aws_instance.win_agent: Still creating... [40s elapsed]
aws_instance.linux_agent: Still creating... [40s elapsed]
aws_instance.linux_agent (puppet): Connecting to remote host via SSH...
aws_instance.linux_agent (puppet):   Host: 54.252.134.38
aws_instance.linux_agent (puppet):   User: ec2-user
aws_instance.linux_agent (puppet):   Password: false
aws_instance.linux_agent (puppet):   Private key: true
aws_instance.linux_agent (puppet):   Certificate: false
aws_instance.linux_agent (puppet):   SSH Agent: true
aws_instance.linux_agent (puppet):   Checking Host Key: false
aws_instance.linux_agent (puppet): Connecting to remote host via SSH...
aws_instance.linux_agent (puppet):   Host: 54.252.134.38
aws_instance.linux_agent (puppet):   User: ec2-user
aws_instance.linux_agent (puppet):   Password: false
aws_instance.linux_agent (puppet):   Private key: true
aws_instance.linux_agent (puppet):   Certificate: false
aws_instance.linux_agent (puppet):   SSH Agent: true
aws_instance.linux_agent (puppet):   Checking Host Key: false
aws_instance.linux_agent (puppet): Connected!
aws_instance.linux_agent (puppet): ip-172-31-10-49.ap-southeast-2.compute.internal
aws_instance.linux_agent: Still creating... [50s elapsed]
aws_instance.win_agent: Still creating... [50s elapsed]
aws_instance.linux_agent: Still creating... [1m0s elapsed]
aws_instance.win_agent: Still creating... [1m0s elapsed]
aws_instance.win_agent: Still creating... [1m10s elapsed]
aws_instance.linux_agent: Still creating... [1m10s elapsed]
aws_instance.win_agent: Still creating... [1m20s elapsed]
aws_instance.linux_agent: Still creating... [1m20s elapsed]
aws_instance.win_agent: Provisioning with 'puppet'...
aws_instance.win_agent (puppet): Connecting to remote host via WinRM...
aws_instance.win_agent (puppet):   Host: 13.211.55.90
aws_instance.win_agent (puppet):   Port: 5985
aws_instance.win_agent (puppet):   User: Administrator
aws_instance.win_agent (puppet):   Password: true
aws_instance.win_agent (puppet):   HTTPS: false
aws_instance.win_agent (puppet):   Insecure: false
aws_instance.win_agent (puppet):   NTLM: false
aws_instance.win_agent (puppet):   CACert: false
aws_instance.win_agent (puppet): Connected!
aws_instance.win_agent (puppet): WIN-IPE5577KSBA
aws_instance.linux_agent (puppet): Info: Downloaded certificate for ca from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.linux_agent (puppet): Info: Downloaded certificate revocation list for ca from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.linux_agent (puppet): Info: Creating a new RSA SSL key for ip-172-31-10-49.ap-southeast-2.compute.internal
aws_instance.win_agent (puppet): ap-southeast-2.compute.internal
aws_instance.linux_agent (puppet): Info: csr_attributes file loading from /etc/puppetlabs/puppet/csr_attributes.yaml
aws_instance.linux_agent (puppet): Info: Creating a new SSL certificate request for ip-172-31-10-49.ap-southeast-2.compute.internal
aws_instance.linux_agent (puppet): Info: Certificate Request fingerprint (SHA256): E3:E8:AD:42:EC:76:EE:F0:DF:47:F9:D1:65:6B:8C:46:0B:59:B2:1A:26:5B:56:B7:55:87:1C:B9:7E:E6:BA:3E
aws_instance.linux_agent (puppet): Info: Downloaded certificate for ip-172-31-10-49.ap-southeast-2.compute.internal from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.win_agent: Still creating... [1m30s elapsed]
aws_instance.linux_agent: Still creating... [1m30s elapsed]
aws_instance.linux_agent (puppet): Info: Using configured environment 'production'
aws_instance.linux_agent (puppet): Info: Retrieving pluginfacts
aws_instance.linux_agent (puppet): Info: Retrieving plugin
aws_instance.linux_agent (puppet): Info: Retrieving locales


aws_instance.win_agent (puppet):     Directory: C:\ProgramData\PuppetLabs\Puppet


aws_instance.win_agent (puppet): Mode                LastWriteTime     Length Name
aws_instance.win_agent (puppet): ----                -------------     ------ ----
aws_instance.win_agent (puppet): d----        10/12/2019  11:47 AM            etc


aws_instance.linux_agent (puppet): Info: Caching catalog for ip-172-31-10-49.ap-southeast-2.compute.internal
aws_instance.linux_agent (puppet): Info: Applying configuration version '1570880860'
aws_instance.linux_agent (puppet): Notice: Hello world from ip-172-31-10-49!
aws_instance.linux_agent (puppet): Notice: /Stage[main]/Main/Node[default]/Notify[Hello world from ip-172-31-10-49!]/message: defined 'message' as 'Hello world from ip-172-31-10-49!'
aws_instance.linux_agent (puppet): Info: Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml
aws_instance.linux_agent (puppet): Notice: Applied catalog in 0.01 seconds
aws_instance.linux_agent: Creation complete after 1m33s [id=i-06b88138c2feda4cf]
aws_instance.win_agent: Still creating... [1m40s elapsed]
aws_instance.win_agent: Still creating... [1m50s elapsed]
aws_instance.win_agent: Still creating... [2m0s elapsed]
aws_instance.win_agent: Still creating... [2m10s elapsed]
aws_instance.win_agent: Still creating... [2m20s elapsed]
aws_instance.win_agent: Still creating... [2m30s elapsed]
aws_instance.win_agent: Still creating... [2m40s elapsed]
aws_instance.win_agent (puppet): Info: Downloaded certificate for ca from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.win_agent (puppet): Info: Downloaded certificate revocation list for ca from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.win_agent (puppet): Info: Creating a new RSA SSL key for win-ipe5577ksba.ap-southeast-2.compute.internal
aws_instance.win_agent: Still creating... [2m50s elapsed]
aws_instance.win_agent (puppet): Info: csr_attributes file loading from C:/ProgramData/PuppetLabs/puppet/etc/csr_attributes.yaml
aws_instance.win_agent (puppet): Info: Creating a new SSL certificate request for win-ipe5577ksba.ap-southeast-2.compute.internal
aws_instance.win_agent (puppet): Info: Certificate Request fingerprint (SHA256): A1:C0:D3:AD:24:C7:80:67:F1:F4:97:FC:06:E2:16:01:12:DA:02:5F:AA:2F:57:98:9F:7D:2A:34:42:3C:D3:50
aws_instance.win_agent (puppet): Info: Downloaded certificate for win-ipe5577ksba.ap-southeast-2.compute.internal from ec2-13-239-139-194.ap-southeast-2.compute.amazonaws.com
aws_instance.win_agent (puppet): Info: Using configured environment 'production'
aws_instance.win_agent (puppet): Info: Retrieving pluginfacts
aws_instance.win_agent (puppet): Info: Retrieving plugin
aws_instance.win_agent (puppet): Info: Retrieving locales
aws_instance.win_agent (puppet): Info: Caching catalog for win-ipe5577ksba.ap-southeast-2.compute.internal
aws_instance.win_agent (puppet): Info: Applying configuration version '1570880943'
aws_instance.win_agent (puppet): Notice: Hello world from WIN-IPE5577KSBA!
aws_instance.win_agent (puppet): Notice: /Stage[main]/Main/Node[default]/Notify[Hello world from WIN-IPE5577KSBA!]/message: defined 'message' as 'Hello world from WIN-IPE5577KSBA!'
aws_instance.win_agent (puppet): Info: Creating state file C:/ProgramData/PuppetLabs/puppet/cache/state/state.yaml
aws_instance.win_agent (puppet): Notice: Applied catalog in 0.02 seconds
aws_instance.win_agent: Creation complete after 2m55s [id=i-07da31c6a0bf6ce14]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

## Acknowledgements

Thanks to Tim Sharpe at Puppet for writing the provisioner and assisting! Also thanks to Green Reed Technology for their earlier Puppet Provisioner [docs](https://www.greenreedtech.com/terraform-puppet-provisioner/).

## License

MIT.

## See also

My [blog](https://alexharv074.github.io/2019/10/12/adventures-in-the-terraform-dsl-part-viii-the-puppet-provisioner.html) post.
