# unzip swig screen parted curl euca2ools - extra packages
class nova::utilities {
  if $::osfamily == 'Debian' {
    define nova::utilities::install(){
      if !defined(Package[$title]){
        package { $title:
          ensure => present
        }
      }
    }
    $pkgs=['unzip', 'screen', 'parted', 'curl', 'euca2ools']
    nova::utilities::install{$pkgs:}
  }
}
