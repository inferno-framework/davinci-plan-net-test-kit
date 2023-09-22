require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceLocationAddressCityForwardChainSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService that populate the address-city field of a Location instance'
      description %(
        A server SHALL be capable of supporting chaining for address-city.

        This test will perform a search with address-city and
        will pass if a address-city resource is found in the response.
      )

      id :davinci_plan_net_v110_location_address_city_forward_chain_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          chain_param: 'address-city',
          chain_param_base: 'location',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.chain_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Location', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end