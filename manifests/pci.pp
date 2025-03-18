# Class nova::pci
#
# Configures nova pci options
#
# === Parameters:
#
#  [*aliases*]
#   (optional) A list of pci alias hashes
#   Defaults to []
#   Example:
#   [{"vendor_id" => "1234", "product_id" => "5678", "name" => "default"},
#    {"vendor_id" => "1234", "product_id" => "6789", "name" => "other"}]

class nova::pci(
  Array[Hash] $aliases = []
) {
  include nova::deps

  if empty($aliases) {
    $aliases_real = $facts['os_service_default']
  } else {
    $aliases_real = to_array_of_json_strings($aliases)
  }
  nova_config {
    'pci/alias': value => $aliases_real;
  }
}
