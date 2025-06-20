require_relative '../../../must_support_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleMustSupportTest < Inferno::Test
      include DaVinciPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the PractitionerRole resources returned'
      description %(
        Plan Net Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the Plan Net Server Capability
        Statement. This test will look through the PractitionerRole resources
        found previously for the following must support elements:

        * PractitionerRole.active
        * PractitionerRole.availableTime
        * PractitionerRole.availableTime.allDay
        * PractitionerRole.availableTime.availableEndTime
        * PractitionerRole.availableTime.availableStartTime
        * PractitionerRole.availableTime.daysOfWeek
        * PractitionerRole.code
        * PractitionerRole.endpoint
        * PractitionerRole.extension:network-reference
        * PractitionerRole.extension:newpatients
        * PractitionerRole.extension:qualification
        * PractitionerRole.extension:qualification.extension:code
        * PractitionerRole.extension:qualification.extension:identifier
        * PractitionerRole.extension:qualification.extension:issuer
        * PractitionerRole.extension:qualification.extension:period
        * PractitionerRole.extension:qualification.extension:status
        * PractitionerRole.extension:qualification.extension:whereValid
        * PractitionerRole.healthcareService
        * PractitionerRole.identifier.type
        * PractitionerRole.identifier.value
        * PractitionerRole.location
        * PractitionerRole.notAvailable
        * PractitionerRole.notAvailable.description
        * PractitionerRole.notAvailable.during
        * PractitionerRole.organization
        * PractitionerRole.period
        * PractitionerRole.practitioner
        * PractitionerRole.specialty
        * PractitionerRole.telecom
        * PractitionerRole.telecom.extension:contactpoint-availabletime
        * PractitionerRole.telecom.extension:via-intermediary
        * PractitionerRole.telecom.rank
        * PractitionerRole.telecom.system
        * PractitionerRole.telecom.value
      )

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@3'

      id :davinci_plan_net_v110_practitioner_role_must_support_test

      def resource_type
        'PractitionerRole'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
