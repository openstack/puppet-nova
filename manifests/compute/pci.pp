# Class nova::compute::pci
#
# Configures nova compute pci options
#
# === Parameters:
#
#  [*passthrough*]
#   (optional) Pci passthrough list of hash.
#   Defaults to $facts['os_service_default']
#   Example of format:
#   [ { "vendor_id" => "1234","product_id" => "5678" },
#     { "vendor_id" => "4321","product_id" => "8765", "physical_network" => "default" } ]
#
#  [*report_in_placement*]
#   (optional) Enable PCI resource inventory reporting to Placement.
#   Defaults to $facts['os_service_default']
#
class nova::compute::pci(
  $passthrough         = $facts['os_service_default'],
  $report_in_placement = $facts['os_service_default'],
) {
  include nova::deps

  if !is_service_default($passthrough) and !empty($passthrough) {
    $passthrough_real = to_array_of_json_strings($passthrough)
  } else {
    $passthrough_real = $facts['os_service_default']
  }

  nova_config {
    'pci/device_spec':         value => $passthrough_real;
    'pci/report_in_placement': value => $report_in_placement;
  }
}
