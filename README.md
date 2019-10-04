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

## Troubleshooting

Where I'm stuck now:

```text
▶ bolt task run --nodes ://13.54.94.80 -u ec2-user --run-as root --no-host-key-check --format json --connect-timeout 120 puppet_agent::install > response.json
```

That response contains:

```json
{
  "items": [
    {
      "node": "://54.252.143.233",
      "target": "://54.252.143.233",
      "action": null,
      "object": null,
      "status": "failure",
      "result": {
        "_error": {
          "kind": "puppetlabs.tasks/exception-error",
          "issue_code": "EXCEPTION",
          "msg": "logger must have a name",
          "details": {
            "class": "ArgumentError",
            "stack_trace": "/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:149:in `initialize'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:56:in `new'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:56:in `block in []'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:162:in `block in synchronize'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:159:in `synchronize'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:159:in `synchronize'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:52:in `[]'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh/connection.rb:31:in `initialize'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh.rb:68:in `new'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh.rb:68:in `with_connection'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/sudoable.rb:84:in `run_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:129:in `block in batch_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:71:in `with_events'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:127:in `batch_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:264:in `block (3 levels) in run_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:225:in `with_node_logging'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:263:in `block (2 levels) in run_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:103:in `block (3 levels) in queue_execute'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:348:in `run_task'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:337:in `block (3 levels) in create_worker'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `loop'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `block (2 levels) in create_worker'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `catch'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `block in create_worker'\\n/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/diagnostic_context.rb:474:in `block in create_with_logging_context'"
          }
        }
      }
    }
  ],
  "node_count": 1,
  "elapsed_time": 0
}
```

Parse that:

```text
▶ printf "$(jq -r '.items[].result._error.details.stack_trace' response.json)"
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:149:in `initialize'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:56:in `new'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:56:in `block in []'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:162:in `block in synchronize'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:159:in `synchronize'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/utils.rb:159:in `synchronize'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/logger.rb:52:in `[]'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh/connection.rb:31:in `initialize'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh.rb:68:in `new'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/ssh.rb:68:in `with_connection'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/sudoable.rb:84:in `run_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:129:in `block in batch_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:71:in `with_events'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/transport/base.rb:127:in `batch_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:264:in `block (3 levels) in run_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:225:in `with_node_logging'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:263:in `block (2 levels) in run_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/bolt-1.27.0/lib/bolt/executor.rb:103:in `block (3 levels) in queue_execute'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:348:in `run_task'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:337:in `block (3 levels) in create_worker'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `loop'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:320:in `block (2 levels) in create_worker'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `catch'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/concurrent-ruby-1.1.5/lib/concurrent/executor/ruby_thread_pool_executor.rb:319:in `block in create_worker'
/opt/puppetlabs/bolt/lib/ruby/gems/2.5.0/gems/logging-2.2.2/lib/logging/diagnostic_context.rb:474:in `block in create_with_logging_context'
```
