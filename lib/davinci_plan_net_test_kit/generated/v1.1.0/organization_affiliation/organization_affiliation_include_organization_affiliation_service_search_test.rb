require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationAffiliationIncludeOrganizationAffiliationServiceSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns HealthcareService resources from OrganizationAffiliation search with _include=OrganizationAffiliation:service'
      description %(
        A server SHALL be capable of supporting _includes on search parameter OrganizationAffiliation:service.

        This test will perform a search on OrganizationAffiliation with _include=OrganizationAffiliation:service 
        and the '_id' search parameter using an id with a reference to a HealthcareService
        identified during instance gathering. The test will pass if at least one HealthcareService 
        resource is found in the response and each instance that does is referenced by a returned OrganizationAffiliation instance.
      )

      id :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_service_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'OrganizationAffiliation',
          search_param_names: [],
          include_param: 'OrganizationAffiliation:service',
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
        scratch[:organization_affiliation_resources] ||= {}
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