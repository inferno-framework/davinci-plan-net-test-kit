require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class OrganizationAffiliationParticipatingOrganizationSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Server returns valid results for OrganizationAffiliation search by participating-organization'
      description %(
A server SHALL support searching by
participating-organization on the OrganizationAffiliation resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[US Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :us_core_v110_organization_affiliation_participating_organization_search_test
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'OrganizationAffiliation',
        search_param_names: ['participating-organization']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end
