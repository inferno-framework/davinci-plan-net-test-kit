require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationReferenceResolutionTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within Organization resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding US Core profile.

        Elements which may provide external references include:

        * Organization.endpoint
        * Organization.partOf
      )

      id :davinci_pdex_plan_net_v110_organization_reference_resolution_test

      def resource_type
        'Organization'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end