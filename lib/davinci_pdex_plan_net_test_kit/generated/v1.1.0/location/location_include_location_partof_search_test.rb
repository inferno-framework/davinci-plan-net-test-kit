require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationIncludeLocationPartofSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from Location search with _include=Location:partof'
      description %(
        A server SHALL be capable of supporting _includes for Location:partof.

        This test will perform a search with _include=Location:partof and
        will pass if a Location resource is found in the response.
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

      def scratch_include_resources
        scratch[:location_resources] ||= {}
      end

      run do
        run_include_search_test
      end
    end
  end
end