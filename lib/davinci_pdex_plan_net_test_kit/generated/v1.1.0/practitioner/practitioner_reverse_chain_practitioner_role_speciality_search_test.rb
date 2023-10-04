require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerReverseChainPractitionerRoleSpecialitySearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Example Test of _has:PractitionerRole:practitioner:speciality'
      description %(
        Placeholder test for reverse chaining
      )
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Practitioner',
          search_param_names: [],
          input_name: 'practitioner_role_speciality_input',
          reverse_chain_param: 'speciality',
          reverse_chain_target: 'practitioner',
          additional_resource_type: 'PractitionerRole'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'practitioner_role', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_resources] ||= {}
      end

      def scratch_chain_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_reverse_chain_search_test
      end
    end
  end
end
