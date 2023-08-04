require_relative '../../../must_support_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class EndpointMustSupportTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the Endpoint resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the Endpoint resources
        found previously for the following must support elements:

        * Endpoint.address
        * Endpoint.connectionType
        * Endpoint.contact
        * Endpoint.contact.system
        * Endpoint.contact.value
        * Endpoint.extension:endpoint-usecase
        * Endpoint.managingOrganization
        * Endpoint.name
        * Endpoint.payloadMimeType
        * Endpoint.payloadType
        * Endpoint.status
      )

      id :us_core_v110_endpoint_must_support_test

      def resource_type
        'Endpoint'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
