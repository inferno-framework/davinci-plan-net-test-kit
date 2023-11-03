require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReverseChainOrganizationAffiliationParticipatingOrganizationLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of reverse chaining through OrganizationAffiliation\'s location element'
      description %(
        Test will perform a search using the reverse chaining parameter 
        _has:OrganizationAffiliation:participating-organization:location
        using a value from either a previously identified OrganizationAffiliation when 
        run as a whole suite, or the "\'location\' value from an OrganizationAffiliation 
        instance with \'participating-organization\' populated" input when run at the group level. To validate the 
        returned instances, the test will perform a search 
        on the OrganizationAffiliation resource type using the same location search 
        parameter and value and check that the instances returned by the tested search are all referenced
        by the participating-organization element of instances returned by the additional search.
      )
      
      id :davinci_plan_net_v110_organization_reverse_chain_organization_affiliation_participating_organization_location_search_test
      input :organization_affiliation_participating_organization_location_input,
        title: '\'location\' value from an OrganizationAffiliation instance with \'participating-organization\' populated',
        description: 'Single value from the \'location\' element of an OrganizationAffiliation
        on an instance that also references an Organization instance in its \'participating-organization\' element to be used for test 
        \'Server capable of reverse chaining through OrganizationAffiliation\'s location element\' when run at the group level.',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_participating_organization_location_input',
          reverse_chain_param: 'location',
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
