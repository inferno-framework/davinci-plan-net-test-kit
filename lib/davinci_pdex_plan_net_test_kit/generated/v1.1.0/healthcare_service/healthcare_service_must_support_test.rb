require_relative '../../../must_support_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceMustSupportTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the HealthcareService resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the HealthcareService resources
        found previously for the following must support elements:

        * HealthcareService.active
        * HealthcareService.appointmentRequired
        * HealthcareService.availabilityExceptions
        * HealthcareService.availableTime
        * HealthcareService.availableTime.allDay
        * HealthcareService.availableTime.availableEndTime
        * HealthcareService.availableTime.availableStartTime
        * HealthcareService.availableTime.daysOfWeek
        * HealthcareService.category
        * HealthcareService.comment
        * HealthcareService.coverageArea
        * HealthcareService.endpoint
        * HealthcareService.extension:deliverymethod
        * HealthcareService.extension:newpatients
        * HealthcareService.identifier.type
        * HealthcareService.identifier.value
        * HealthcareService.location
        * HealthcareService.name
        * HealthcareService.notAvailable
        * HealthcareService.notAvailable.description
        * HealthcareService.notAvailable.during
        * HealthcareService.providedBy
        * HealthcareService.specialty
        * HealthcareService.telecom
        * HealthcareService.telecom.extension:contactpoint-availabletime
        * HealthcareService.telecom.extension:via-intermediary
        * HealthcareService.telecom.system
        * HealthcareService.telecom.value
        * HealthcareService.type
      )

      id :davinci_pdex_plan_net_v110_healthcare_service_must_support_test

      def resource_type
        'HealthcareService'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
