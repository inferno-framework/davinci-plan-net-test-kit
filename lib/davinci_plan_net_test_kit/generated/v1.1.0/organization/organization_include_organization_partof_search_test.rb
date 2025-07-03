require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationIncludeOrganizationPartofSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from Organization search with _include=Organization:partof'
      description %(
        A server SHALL be capable of supporting _includes on search parameter Organization:partof.

        This test will perform a search on Organization with _include=Organization:partof 
        and the '_id' search parameter using an id with a reference to an Organization
        identified during instance gathering. The test will pass if at least one Organization 
        resource is found in the response and each instance that does is referenced by a returned Organization instance.
      )

      id :davinci_plan_net_v110_include_organization_organization_partof_search_test

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@27'

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Organization',
          search_param_names: [],
          include_param: 'Organization:partof',
          inc_param_sp: 'partof',
          additional_resource_type: 'Organization'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'organization', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end