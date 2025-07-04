require_relative '../../../must_support_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationMustSupportTest < Inferno::Test
      include DaVinciPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the Organization resources returned'
      description %(
        Plan Net Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the Plan Net Server Capability
        Statement. This test will look through the Organization resources
        found previously for the following must support elements:

        * Organization.active
        * Organization.address
        * Organization.address.city
        * Organization.address.country
        * Organization.address.extension:geolocation
        * Organization.address.line
        * Organization.address.postalCode
        * Organization.address.state
        * Organization.address.text
        * Organization.address.type
        * Organization.contact
        * Organization.contact.telecom
        * Organization.contact.telecom.system
        * Organization.contact.telecom.use
        * Organization.contact.telecom.value
        * Organization.endpoint
        * Organization.extension:org-description
        * Organization.extension:qualification
        * Organization.identifier
        * Organization.identifier.system
        * Organization.identifier.type
        * Organization.identifier.value
        * Organization.identifier:NPI
        * Organization.name
        * Organization.partOf
        * Organization.telecom
        * Organization.telecom.extension:contactpoint-availabletime
        * Organization.telecom.extension:via-intermediary
        * Organization.telecom.rank
        * Organization.telecom.system
        * Organization.telecom.value
        * Organization.type
      )

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@3'

      id :davinci_plan_net_v110_organization_must_support_test

      def resource_type
        'Organization'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
