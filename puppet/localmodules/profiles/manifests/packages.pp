# Class: profiles::packages
#
#
class profiles::packages {
  package { 'git':
    ensure  => 'installed',
  }
  package { 'maven':
    ensure  => 'installed',
  }
  package { 'java-1.8.0-openjdk-devel':
    ensure  => 'installed',
  }
}
