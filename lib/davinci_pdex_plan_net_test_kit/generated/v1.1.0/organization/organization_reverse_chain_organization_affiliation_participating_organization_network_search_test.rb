require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReverseChainOrganizationAffiliationParticipatingOrganizationNetworkSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through OrganizationAffiliation\'s network field'
      description %(
        A server SHALL support reverse chaining.

        Test will use the query _has:OrganizationAffiliation:participating-organization:network to test
        the server for reverse chaining capability.  This test does not validate returned resources at this time.
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_organization_affiliation_participating_organization_network_search_test
      input :organization_affiliation_participating_organization_network_input,
        title: 'network field value for OrganizationAffiliation',
        description: 'Value from the network field of an OrganizationAffiliation
        that also references a Organization instance in its participating-organization field',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_participating_organization_network_input',
          reverse_chain_param: 'network',
          reverse_chain_target: 'participating-organization',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization_affiliation', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
