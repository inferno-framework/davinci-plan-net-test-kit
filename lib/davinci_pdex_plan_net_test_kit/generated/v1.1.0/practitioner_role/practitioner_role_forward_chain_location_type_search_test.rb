require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRoleForwardChainLocationTypeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with location.type'
      description %(
        A server SHALL be capable of supporting chaining for type through the search parameter location
        for the Practitioner_role profile.

        This test will perform a search with location.type and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :davinci_plan_net_v110_forward_chain_location_type_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          chain_param: 'type',
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
        scratch[:practitioner_role_resources] ||= {}
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