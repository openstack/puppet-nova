# unzip swig screen parted curl euca2ools - extra packages
class nova::utilities {
  define nova::utilities::install(){
    if !defined(Package[$title]){
      package { $title:
        ensure => present
      }
    }
  }
  if $::osfamily == 'Debian' {
    $pkgs=['unzip', 'screen', 'parted', 'curl', 'euca2ools']
    nova::utilities::install{$pkgs:}
  }
}
