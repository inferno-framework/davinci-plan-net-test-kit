require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class HealthcareServiceRevincludePractitionerRoleServiceSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from HealthcareService search with _revinclude=PractitionerRole:service'
      description %(
        A server SHALL be capable of supporting searches _revincludes on search parameter PractitionerRole:service.

        This test will perform a search on HealthcareService with _revinclude=PractitionerRole:service and the '_id'
        search parameter using an id previously identified during a suite level run or an id provided
        in the "HealthcareService instance ids referenced in PractitionerRole.service" input if run at the group level.
        The test will pass if at least one PractitionerRole resource found in the response
        and each instance that does includes a reference to the HealthcareService with the searched id.
      )

      id :davinci_plan_net_v110_revinclude_healthcare_service_practitioner_role_service_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@28'

      input :practitioner_role_service_input,
        title: 'HealthcareService instance ids referenced in PractitionerRole.service',
        description: %(Comma separated list of HealthcareService instance ids that are referenced by a PractitionerRole
        instance in its service element. Used for test "Server returns PractitionerRole resources from HealthcareService search with _revinclude=PractitionerRole:service"
        when run at the group level.),
        optional: true
        
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'practitioner_role_service_input',
          revinclude_param: 'PractitionerRole:service',
          rev_param_sp: 'service',
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
        scratch[:healthcare_service_resources] ||= {}
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
