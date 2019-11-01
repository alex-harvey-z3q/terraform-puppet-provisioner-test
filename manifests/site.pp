node default {
  notify { "Hello world from ${facts['hostname']}!": }
  wait_for { 'five seconds':
    seconds     => 5,
    refreshonly => true,
    subscribe   => Notify["Hello world from ${facts['hostname']}!"],
  }
}
