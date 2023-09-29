require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationForwardChainLocationAddressPostalcodeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with location.address-postalcode'
      description %(
        A server SHALL be capable of supporting chaining for address-postalcode through the search parameter location
        for the Organization_affiliation profile.

        This test will perform a search with location.address-postalcode and
        will pass if an OrganizationAffiliation resource is found in the response.
      )

      id :davinci_plan_net_v110_forward_chain_location_address_postalcode_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          chain_param: 'address-postalcode',
          chain_param_base: 'location',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'location', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
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