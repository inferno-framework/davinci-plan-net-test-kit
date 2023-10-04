require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReverseChainOrganizationAffiliationSpecialitySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Example Test of _has:OrganizationAffiliation:participating-organization:speciality'
      description %(
        Placeholder test for reverse chaining
      )
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          input_name: 'organization_affiliation_speciality_input',
          reverse_chain_param: 'speciality',
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

      def scratch_chain_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
