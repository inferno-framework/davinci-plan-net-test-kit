require_relative '../../../must_support_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PlannetNetworkMustSupportTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::MustSupportTest

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
        * Organization.address.line
        * Organization.address.postalCode
        * Organization.address.state
        * Organization.contact
        * Organization.contact.name
        * Organization.contact.telecom
        * Organization.contact.telecom.system
        * Organization.contact.telecom.value
        * Organization.endpoint
        * Organization.extension:location-reference
        * Organization.identifier
        * Organization.identifier.system
        * Organization.identifier.type
        * Organization.identifier.value
        * Organization.identifier:NPI
        * Organization.name
        * Organization.partOf
        * Organization.telecom
        * Organization.type
      )

      id :davinci_pdex_plan_net_v110_plannet_network_must_support_test

      def resource_type
        'Organization'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:plannet_network_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
