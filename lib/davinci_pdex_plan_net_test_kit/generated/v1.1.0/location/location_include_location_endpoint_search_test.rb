require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationIncludeLocationEndpointSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Endpoint resources from Location search with _include=Location:endpoint'
      description %(
        A server SHALL be capable of supporting _includes on search parameter Location:endpoint.

        This test will perform a search on Location with _include=Location:endpoint 
        and the '_id' search parameter using an id with a reference to a Endpoint
        identified during instance gathering. The test will pass if at least one Endpoint 
        resource is found in the response and each instance that does is referenced by a returned Location instance.
      )

      id :davinci_plan_net_v110_include_location_location_endpoint_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          include_param: 'Location:endpoint',
          inc_param_sp: 'endpoint',
          additional_resource_type: 'Endpoint'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'endpoint', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:endpoint_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end