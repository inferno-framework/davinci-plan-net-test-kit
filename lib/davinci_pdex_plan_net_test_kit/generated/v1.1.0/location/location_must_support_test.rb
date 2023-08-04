require_relative '../../../must_support_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationMustSupportTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the Location resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Location resources
        found previously for the following must support elements:

        * Location.address
        * Location.address.city
        * Location.address.line
        * Location.address.postalCode
        * Location.address.state
        * Location.alias
        * Location.availabilityExceptions
        * Location.description
        * Location.endpoint
        * Location.extension:accessibility
        * Location.extension:newpatients
        * Location.extension:region
        * Location.hoursOfOperation
        * Location.hoursOfOperation.allDay
        * Location.hoursOfOperation.closingTime
        * Location.hoursOfOperation.daysOfWeek
        * Location.hoursOfOperation.openingTime
        * Location.identifier.type
        * Location.identifier.value
        * Location.managingOrganization
        * Location.name
        * Location.partOf
        * Location.position
        * Location.status
        * Location.telecom
        * Location.telecom.extension:contactpoint-availabletime
        * Location.telecom.extension:via-intermediary
        * Location.telecom.system
        * Location.telecom.value
        * Location.type
      )

      id :davinci_pdex_plan_net_v110_location_must_support_test

      def resource_type
        'Location'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
