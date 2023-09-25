require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanAdministeredByPartofForwardChainSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns InsurancePlan that populate the partof field of a Organization instance
      through the search parameter administered-by'
      description %(
        A server SHALL be capable of supporting chaining for partof.

        This test will perform a search with partof and
        will pass if a partof resource is found in the response.
      )

      id :davinci_plan_net_v110_administered_by_partof_forward_chain_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          chain_param: 'partof',
          chain_param_base: 'administered-by',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
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