require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrgAffilForwardChainPrimaryOrganizationPartofSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of forward chaining with primary-organization.partof'
      description %(
        A server SHALL be capable of supporting chaining for partof through the search parameter primary-organization
        for the Org_affil profile.

        This test will perform a search with primary-organization.partof using a value
        in the partof element on an instance found during _include tests executed
        previously during this sequence. To validate the returned instances, the test will perform a search 
        on the Organization resource type using the same partof search 
        parameter and value and check that this search contains any instances referenced through the 
        primary-organization element of instances returned by the tested search.
      )

      id :davinci_plan_net_v110_forward_chain_org_affil_primary_organization_partof_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          chain_param: 'partof',
          chain_param_base: 'primary-organization',
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
        scratch[:org_affil_resources] ||= {}
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