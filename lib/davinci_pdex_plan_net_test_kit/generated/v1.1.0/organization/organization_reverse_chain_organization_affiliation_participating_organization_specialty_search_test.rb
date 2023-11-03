require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReverseChainOrganizationAffiliationParticipatingOrganizationSpecialtySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through OrganizationAffiliation\'s specialty element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:OrganizationAffiliation:participating-organization:specialty
        using a value from either a previously identified OrganizationAffiliation when 
        run as a whole suite, or the "\'specialty\' value from an OrganizationAffiliation 
        instance with \'participating-organization\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the OrganizationAffiliation resource type using the same specialty search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the participating-organization element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_organization_affiliation_participating_organization_specialty_search_test
      input :organization_affiliation_participating_organization_specialty_input,
        title: '\'specialty\' value from an OrganizationAffiliation instance with \'participating-organization\' populated',
        description: 'Single value from the \'specialty\' element of an OrganizationAffiliation
        on an instance that also references an Organization instance in its \'participating-organization\' element to be used for test 
        \'Server capable of reverse chaining through OrganizationAffiliation\'s specialty element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_participating_organization_specialty_input',
          reverse_chain_param: 'specialty',
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
