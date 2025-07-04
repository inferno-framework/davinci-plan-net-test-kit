require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationRevincludePractitionerRoleLocationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from Location search with _revinclude=PractitionerRole:location'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter PractitionerRole:location.

        This test will perform a search on Location with _revinclude=PractitionerRole:location and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "Location instance ids referenced in PractitionerRole.location" input if run at the group level.
        The test will pass if at least one PractitionerRole resource found in the response
        and each instance that does includes a reference to the Location with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_location_practitioner_role_location_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@28'

      input :practitioner_role_location_input,
        title: 'Location instance ids referenced in PractitionerRole.location',
        description: %(Comma separated list of Location instance ids that are referenced by a PractitionerRole
        instance in its location element. Used for test "Server returns PractitionerRole resources from Location search with _revinclude=PractitionerRole:location"
        when run at the group level.),
        optional: true
        
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'practitioner_role_location_input',
          revinclude_param: 'PractitionerRole:location',
          rev_param_sp: 'location',
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
        scratch[:location_resources] ||= {}
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
