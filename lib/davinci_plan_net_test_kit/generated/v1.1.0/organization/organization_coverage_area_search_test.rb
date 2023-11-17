require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationCoverageAreaSearchTest < Inferno::Test
      include DaVinciPlanNetTestKit::SearchTest

      title 'Server returns valid results for Organization search by coverage-area'
      description %(
A server SHALL support searching by
coverage-area on the Organization resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[Plan Net Server CapabilityStatement](http://hl7.org/fhir/us/davinci-pdex-plan-net/CapabilityStatement/plan-net)

      )

      id :davinci_plan_net_v110_organization_coverage_area_search_test
      optional
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Organization',
        search_param_names: ['coverage-area']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
