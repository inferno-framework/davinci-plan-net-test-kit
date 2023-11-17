require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanForwardChainAdministeredByPartofSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with administered-by.partof'
      description %(
        A server SHALL be capable of supporting chaining for partof through the search parameter administered-by
        for the Insurance_plan profile.

        This test will perform a search with administered-by.partof using a value
        in the partof element on an instance found during _include tests executed
        previously during this sequence. To validate the returned instances, the test will perform a search 
        on the Organization resource type using the same partof search 
        parameter and value and check that this search contains any instances referenced through the 
        administered-by element of instances returned by the tested search.
      )

      id :davinci_plan_net_v110_forward_chain_administered_by_partof_search_test

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

      def scratch_additional_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_forward_chain_search_test
      end
    end
  end
end