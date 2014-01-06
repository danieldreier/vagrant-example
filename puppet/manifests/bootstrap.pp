node default {
  package { 'rubygems': ensure => 'installed' }
  package { 'librarian-puppet':
    ensure   => 'installed',
    provider => 'gem',
    require  => Package['rubygems'],
  }

  # Run librarian-puppet if Puppetfile changed
  file { '/etc/puppet/Puppetfile':
    mode   => '0644',
    owner  => root,
    group  => root,
    source => '/vagrant/Puppetfile';
  }

  exec { 'run librarian-puppet':
    environment => ['HOME=/root'],
    command     => 'librarian-puppet install',
    path	=> [ '/usr/bin', '/usr/local/bin', '/usr/sbin', '/bin' ],
    cwd         => '/etc/puppet',
    refreshonly => true,
    subscribe   => File['/etc/puppet/Puppetfile'],
    require     => [ File['/etc/puppet/Puppetfile'],
                    Package['librarian-puppet'], ],
  }
}
