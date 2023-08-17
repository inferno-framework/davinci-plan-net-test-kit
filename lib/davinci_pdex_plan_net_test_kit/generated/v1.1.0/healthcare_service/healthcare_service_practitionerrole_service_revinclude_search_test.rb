require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServicePractitionerroleServiceRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns PractitionerRole resources from HealthcareService search by _revinclude=PractitionerRole:service'
      description %(
        A server SHALL be capable of supporting _revIncludes for PractitionerRole:service.

        This test will perform a search by _revinclude=PractitionerRole:service and
        will pass if a PractitionerRole resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_healthcare_service_practitionerrole_service_revinclude_search_test
      input :practitionerrole_service_input,
        title: 'PractitionerRole referenced HealthcareService IDs',
        description: 'Comma separated list of HealthcareService  IDs that are referenced by a PractitionerRole'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'practitionerrole_service_input',
          revinclude_param: 'PractitionerRole:service'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'PractitionerRole', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:practitionerrole_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
