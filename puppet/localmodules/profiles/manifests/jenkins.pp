# profile for installing and configuring jenkins
class profiles::jenkins {
  class { 'java':
    distribution => 'jre'
  }
  package { 'ruby':
    ensure => 'present'
  }
  package { 'rubygems':
    ensure  => 'present',
    require => Package['ruby']
  }
  package { 'ruby-devel':
    ensure  => 'present',
    require => Package['ruby']
  }
  package { 'gcc':
    ensure  => 'present',
    require => Package['ruby']
  }
  package { 'createrepo':
    ensure => 'present'
  }
  package { 'make':
    ensure  => 'present',
    require => Package['ruby']
  }
  package { 'librarian-puppet':
    ensure   => 'present',
    provider => 'gem',
    require  => Package['rubygems']
  }

  include jenkins

  jenkins::plugin { 'ace-editor': }
  jenkins::plugin { 'jquery-detached': }

  jenkins::plugin { 'workflow-job': }
  jenkins::plugin { 'workflow-cps': }
  jenkins::plugin { 'pipeline-model-api': }

  jenkins::plugin { 'pipeline-model-extensions': }
  jenkins::plugin { 'jsch': }
  jenkins::plugin { 'display-url-api': }

  jenkins::plugin { 'workflow-api': }
  jenkins::plugin { 'ssh-credentials': }
  jenkins::plugin { 'plain-credentials': }
  jenkins::plugin { 'git-client': }
  jenkins::plugin { 'mailer': }
  jenkins::plugin { 'token-macro': }
  jenkins::plugin { 'durable-task': }
  jenkins::plugin { 'scm-api': }
  jenkins::plugin { 'workflow-support': }
  jenkins::plugin { 'apache-httpcomponents-client-4-api': }
  jenkins::plugin { 'jackson2-api': }
  jenkins::plugin { 'junit': }

  jenkins::plugin { 'workflow-step-api': }
  jenkins::plugin { 'workflow-scm-step': }
  jenkins::plugin { 'structs': }
  jenkins::plugin { 'workflow-durable-task-step': }
  jenkins::plugin { 'script-security': }
  jenkins::plugin { 'matrix-project': }
  jenkins::plugin { 'resource-disposer': }
  jenkins::plugin { 'bouncycastle-api': }
  jenkins::plugin { 'node-iterator-api': }
  jenkins::plugin { 'aws-credentials': }
  jenkins::plugin { 'aws-java-sdk': }

  jenkins::plugin { 'git': }
  jenkins::plugin { 'ec2': }
  jenkins::plugin { 'build-timeout': }
  jenkins::plugin { 'credentials-binding': }
  jenkins::plugin { 'ws-cleanup': }
  jenkins::plugin { 'xunit': }
  jenkins::plugin { 'sonar': }
  jenkins::plugin { 'timestamper': }
  jenkins::plugin { 'gradle': }
  jenkins::plugin { 'ant': }
  jenkins::plugin { 'authentication-tokens': }
  jenkins::plugin { 'docker-commons': }
  jenkins::plugin { 'docker-build-publish': }



  file { '/var/lib/jenkins/init.groovy.d/':
  ensure  => 'directory',
  source  => 'puppet:///modules/profiles/jenkins/init.groovy/',
  recurse => true,
  owner   => 'jenkins',
  group   => 'jenkins',
  mode    => '0744'
  }

  # jenkins::user { 'user':
  #   email    => 's.zverau@godeltech.com',
  #   password => 'password',
  # }
}
