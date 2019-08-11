node default {
  notify { "Hello world from ${facts['hostname']}!": }
}
