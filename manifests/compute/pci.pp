# Class nova::compute::pci
#
# Configures nova compute pci options
#
# === Parameters:
#
#  [*device_specs*]
#   (optional) Specify the PCI devices available to VMs.
#   Defaults to []
#   Example of format:
#   [ { "vendor_id" => "1234","product_id" => "5678" },
#     { "vendor_id" => "4321","product_id" => "8765", "physical_network" => "default" } ]
#
#  [*report_in_placement*]
#   (optional) Enable PCI resource inventory reporting to Placement.
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
#  [*passthrough*]
#   (optional) Pci passthrough list of hash.
#   Defaults to undef
#
class nova::compute::pci (
  Array[Hash] $device_specs          = [],
  $report_in_placement               = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  Optional[Array[Hash]] $passthrough = undef,
) {
  include nova::deps

  if $passthrough != undef {
    warning('The passthrough parameter is deprecated. Use the device_specs parameter.')
    if empty($passthrough) {
      $device_specs_real = $facts['os_service_default']
    } else {
      $device_specs_real = to_array_of_json_strings($passthrough)
    }
  } else {
    if empty($device_specs) {
      $device_specs_real = $facts['os_service_default']
    } else {
      $device_specs_real = to_array_of_json_strings($device_specs)
    }
  }

  nova_config {
    'pci/device_spec':         value => $device_specs_real;
    'pci/report_in_placement': value => $report_in_placement;
  }
}
