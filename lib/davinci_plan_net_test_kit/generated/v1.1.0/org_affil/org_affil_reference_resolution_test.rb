require_relative '../../../reference_resolution_test'
require_relative '../resource_list'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrgAffilReferenceResolutionTest < Inferno::Test
      include DaVinciPlanNetTestKit::ReferenceResolutionTest
      include ResourceList

      title 'MustSupport references within OrganizationAffiliation resources are valid'
      description %(
        This test will attempt to read external references provided within elements
        marked as 'MustSupport', if any are available.

        It verifies that at least one external reference for each MustSupport Reference element
        can be accessed by the test client, and conforms to corresponding Plan Net profile.

        Elements which may provide external references include:

        * OrganizationAffiliation.endpoint
        * OrganizationAffiliation.healthcareService
        * OrganizationAffiliation.location
        * OrganizationAffiliation.network
        * OrganizationAffiliation.organization
        * OrganizationAffiliation.participatingOrganization
      )

      id :davinci_plan_net_v110_org_affil_reference_resolution_test

      def resource_type
        'OrganizationAffiliation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:org_affil_resources] ||= {}
      end

      run do
        perform_reference_resolution_test(scratch_resources[:all])
      end
    end
  end
end
