require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationOrganizationaffiliationServiceIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from OrganizationAffiliation search by _include=OrganizationAffiliation:service'
      description %(
        A server SHALL be capable of supporting _includes for OrganizationAffiliation:service.

        This test will perform a search by _include=OrganizationAffiliation:service and
        will pass if a HealthcareService resource is found in the response.
      )

      id :davinci_plan_net_v110_v110_organization_affiliation_organizationaffiliation_service_include_search_test
      input :organizationaffiliation_service_input,
        title: 'IDs of OrganizationAffiliation that have HealthcareService reference(s)',
        description: 'Comma separated list of OrganizationAffiliation IDs that reference by a HealthcareService'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          input_name: 'organizationaffiliation_service_input',
          include_param: 'OrganizationAffiliation:service',
          additional_resource_type: 'HealthcareService'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'HealthcareService', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      def scratch_include_resources
        scratch[:healthcareservice_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end