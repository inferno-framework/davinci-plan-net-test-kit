require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleIncludePractitionerRolePractitionerSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Practitioner resources from PractitionerRole search with _include=PractitionerRole:practitioner'
      description %(
        A server SHALL be capable of supporting _includes on search parameter PractitionerRole:practitioner.

        This test will perform a search on PractitionerRole with _include=PractitionerRole:practitioner 
        and the '_id' search parameter using an id with a reference to a Practitioner
        identified during instance gathering. The test will pass if at least one Practitioner 
        resource is found in the response and each instance that does is referenced by a returned PractitionerRole instance.
      )

      id :davinci_plan_net_v110_include_practitioner_role_practitioner_role_practitioner_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          include_param: 'PractitionerRole:practitioner',
          inc_param_sp: 'practitioner',
          additional_resource_type: 'Practitioner'
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
        run_include_search_test
      end
    end
  end
end