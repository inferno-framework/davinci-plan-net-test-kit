require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRevincludePractitionerRolePractitionerSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Practitioner search with _revinclude=PractitionerRole:practitioner'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter PractitionerRole:practitioner.

        This test will perform a search on Practitioner with _revinclude=PractitionerRole:practitioner and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Practitioner instance ids referenced in PractitionerRole.practitioner" input if run at the group level.
        The test will pass if at least one PractitionerRole resource found in the response
        and each instance that does includes a reference to the Practitioner with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_practitioner_practitioner_role_practitioner_search_test
      input :practitioner_role_practitioner_input,
        title: 'Practitioner instance ids referenced in PractitionerRole.practitioner',
        description: %(Comma separated list of Practitioner instance ids that are referenced by a PractitionerRole
        instance in its practitioner element. Used for test "Server returns PractitionerRole resources from Practitioner search with _revinclude=PractitionerRole:practitioner"
        when run at the group level.),
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Practitioner',
          search_param_names: [],
          input_name: 'practitioner_role_practitioner_input',
          revinclude_param: 'PractitionerRole:practitioner',
          rev_param_sp: 'practitioner',
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

      def scratch_additional_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
