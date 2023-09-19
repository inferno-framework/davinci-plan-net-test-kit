require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class LocationLocationPartofIncludeSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns Location resources from Location search by _include=Location:partof'
      description %(
        A server SHALL be capable of supporting _includes for Location:partof.

        This test will perform a search by _include=Location:partof and
        will pass if a Location resource is found in the response.
      )

      id :davinci_plan_net_v110_location_location_partof_include_search_test
      input :location_partof_input,
        title: 'IDs of Location that have Location reference(s)',
        description: 'Comma separated list of Location IDs that reference by a Location',
        optional: true

      def properties
        @properties ||= SearchTestProperties.new(
            resource_type: 'Location',
          search_param_names: [],
          input_name: 'location_partof_input',
          include_param: 'Location:partof',
          additional_resource_type: 'Location'
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml')))
      end

      def self.include_metadata
        @revinclude_metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, '..', 'Location', 'metadata.yml'), aliases: true))
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