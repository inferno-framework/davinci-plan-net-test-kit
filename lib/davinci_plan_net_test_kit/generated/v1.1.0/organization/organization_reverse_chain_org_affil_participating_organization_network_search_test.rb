require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationReverseChainOrgAffilParticipatingOrganizationNetworkSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through OrganizationAffiliation\'s network element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:OrganizationAffiliation:participating-organization:network
        using a value from either a previously identified OrganizationAffiliation when 
        run from the suite level, or the "\'network\' value from an OrganizationAffiliation 
        instance with \'participating-organization\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the OrganizationAffiliation resource type using the same network search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the participating-organization element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_org_affil_participating_organization_network_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@22'

      input :org_affil_participating_organization_network_input,
        title: '\'network\' value from an OrganizationAffiliation instance with \'participating-organization\' populated',
        description: 'Single value from the \'network\' element of an OrganizationAffiliation
        on an instance that also references an Organization instance in its \'participating-organization\' element to be used for test 
        \'Server capable of reverse chaining through OrganizationAffiliation\'s network element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'org_affil_participating_organization_network_input',
          reverse_chain_param: 'network',
          reverse_chain_target: 'participating-organization',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'org_affil', 'metadata.yml'), aliases: true))
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
