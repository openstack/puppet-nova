# This file contains a module to return a default set of facts and supported
# operating systems for the tests in this module.
module OSDefaults
    def self.get_facts(extra_facts={})
      { :os_service_default => '<SERVICE DEFAULT>' }.merge(extra_facts)
    end

    def self.get_supported_os
      [
        {
          "operatingsystem" => "CentOS",
          "operatingsystemrelease" =>  [
            "7.0"
          ]
        },
        {
          "operatingsystem" => "RedHat",
          "operatingsystemrelease" =>  [
            "7.0"
          ]
        },
        {
          "operatingsystem" => "Fedora",
          "operatingsystemrelease" => [
            "21",
            "22"
          ]
        },
        {
          "operatingsystem" =>  "Ubuntu",
          "operatingsystemrelease" =>  [
            "14.04"
         ]
        },
        {
          "operatingsystem" =>  "Debian",
          "operatingsystemrelease" =>  [
            "7",
            "8"
         ]
        }
      ]
    end
end
