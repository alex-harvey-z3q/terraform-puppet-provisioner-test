# Terraform Puppet Provisioner Test

## Dependencies

```text
▶ brew cask install puppetlabs/puppet/puppet-bolt 
▶ bolt --version 
1.27.0
```

## Bolt config

See docs [here](https://puppet.com/docs/bolt/latest/bolt_configuration_options.html).

## Terraform module

### Puppet master

To log on:

```text
▶ aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name==`running`].PublicDnsName' --output text
ec2-13-55-135-160.ap-southeast-2.compute.amazonaws.com
```

SSH config:

```text
Host ec2-*.ap-southeast-2.compute.amazonaws.com
  User ec2-user
  IdentityFile ~/.ssh/default.pem
```

Logon:

```text
ssh ec2-13-55-135-160.ap-southeast-2.compute.amazonaws.com
```

## Usage

Set up Bolt:

```text
▶ bash -x setup.sh
```

Apply Terraform:

```text
▶ terraform init
▶ terraform apply -auto-approve
```
