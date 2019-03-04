class profiles::selinux {
  class { '::selinux':
  mode => 'disabled'
  }
}
