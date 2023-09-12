require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class HealthcareServiceOrganizationAffiliationServiceRevincludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns OrganizationAffiliation resources from HealthcareService search by _revinclude=OrganizationAffiliation:service'
      description %(
        A server SHALL be capable of supporting _revIncludes for OrganizationAffiliation:service.

        This test will perform a search by _revinclude=OrganizationAffiliation:service and
        will pass if a OrganizationAffiliation resource is found in the response.
      )

      id :davinci_plan_net_v110_healthcare_service_organization_affiliation_service_revinclude_search_test
      input :organization_affiliation_service_input,
        title: 'OrganizationAffiliation referenced HealthcareService IDs',
        description: 'Comma separated list of HealthcareService  IDs that are referenced by a OrganizationAffiliation',
        optional: true
        
      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'HealthcareService',
          search_param_names: [],
          input_name: 'organization_affiliation_service_input',
          revinclude_param: 'OrganizationAffiliation:service',
          rev_param_sp: 'service',
          additional_resource_type: 'OrganizationAffiliation'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.revinclude_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'OrganizationAffiliation', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:healthcare_service_resources] ||= {}
      end

      def scratch_revinclude_resources
        scratch[:OrganizationAffiliation_resources] ||= {}
      end

      run do
        run_revinclude_search_test
      end
    end
  end
end
