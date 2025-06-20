require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class PractitionerRoleIncludePractitionerRoleServiceSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from PractitionerRole search with _include=PractitionerRole:service'
      description %(
        A server SHALL be capable of supporting _includes on search parameter PractitionerRole:service.

        This test will perform a search on PractitionerRole with _include=PractitionerRole:service 
        and the '_id' search parameter using an id with a reference to a HealthcareService
        identified during instance gathering. The test will pass if at least one HealthcareService 
        resource is found in the response and each instance that does is referenced by a returned PractitionerRole instance.
      )

      id :davinci_plan_net_v110_include_practitioner_role_practitioner_role_service_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@27'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'PractitionerRole',
          search_param_names: [],
          include_param: 'PractitionerRole:service',
          inc_param_sp: 'service',
          additional_resource_type: 'HealthcareService'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'healthcare_service', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:practitioner_role_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end