require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanForwardChainOwnedByNameSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with owned-by.name'
      description %(
        A server SHALL be capable of supporting chaining for name through the search parameter owned-by
        for the Insurance_plan profile.

        This test will perform a search with owned-by.name using a value
        in the name element on an instance found during _include tests executed
        previously during this sequence. To validate the returned instances, the test will perform a search 
        on the Organization resource type using the same name search 
        parameter and value and check that this search contains any instances referenced through the 
        owned-by element of instances returned by the tested search.
      )

      id :davinci_plan_net_v110_forward_chain_owned_by_name_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'InsurancePlan',
          search_param_names: [],
          chain_param: 'name',
          chain_param_base: 'owned-by',
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

      def scratch_additional_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end