require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRoleCombinationListPractitionersWithSpecialtyAndLocationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server capable of combination search, e.g. being able to List all clinicians of a certain specialty within a location'
      description %(
        A server SHALL support searching with a combination of parameters.  This specific test will attempt to filter practitioners by specialty and location fields of the role that references them.
      )
      
      id :davinci_plan_net_v110_practitioner_role_combination_list_practitioners_with_specialty_and_location_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: ['specialty', 'location'],
          input_name: 'combination_list_practitioners_with_specialty_and_location_input',
          include_param: 'PractitionerRole:practitioner',
          inc_param_sp: 'practitioner',
          additional_resource_type: 'Practitioner',
          combination_search: true
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'practitioner', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:practitioner_resources] ||= {}
      end

      run do
        run_combination_search_test
      end
    end
  end
end
