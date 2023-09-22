require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class NetworkPartofTypeForwardChainSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Organization that populate the type field of a Organization instance'
      description %(
        A server SHALL be capable of supporting chaining for type.

        This test will perform a search with type and
        will pass if a type resource is found in the response.
      )

      id :davinci_plan_net_v110_partof_type_forward_chain_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          chain_param: 'type',
          chain_param_base: 'partof',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.chain_metadata
        @include_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:network_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end