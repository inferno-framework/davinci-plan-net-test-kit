require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationIncludeLocationOrganizationSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns Organization resources from Location search with _include=Location:organization'
      description %(
        A server SHALL be capable of supporting _includes on search parameter Location:organization.

        This test will perform a search on Location with _include=Location:organization 
        and the '_id' search parameter using an id with a reference to a Organization
        identified during instance gathering. The test will pass if at least one Organization 
        resource is found in the response and each instance that does is referenced by a returned Location instance.
      )

      id :davinci_plan_net_v110_include_location_location_organization_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          include_param: 'Location:organization',
          inc_param_sp: 'organization',
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
        scratch[:location_resources] ||= {}
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