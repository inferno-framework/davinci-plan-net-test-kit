require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationIncludeLocationPartofSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from Location search with _include=Location:partof'
      description %(
        A server SHALL be capable of supporting _includes on search parameter Location:partof.

        This test will perform a search on Location with _include=Location:partof 
        and the '_id' search parameter using an id with a reference to a Location
        identified during instance gathering. The test will pass if at least one Location 
        resource is found in the response and each instance that does is referenced by a returned Location instance.
      )

      id :davinci_plan_net_v110_include_location_location_partof_search_test

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          include_param: 'Location:partof',
          inc_param_sp: 'partof',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.additional_metadata
        @additional_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'location', 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:location_resources] ||= {}
      end

      def scratch_additional_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end