require_relative '../../../must_support_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrgAffilMustSupportTest < Inferno::Test
      include DaVinciPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the OrganizationAffiliation resources returned'
      description %(
        Plan Net Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the Plan Net Server Capability
        Statement. This test will look through the OrganizationAffiliation resources
        found previously for the following must support elements:

        * OrganizationAffiliation.active
        * OrganizationAffiliation.code
        * OrganizationAffiliation.endpoint
        * OrganizationAffiliation.healthcareService
        * OrganizationAffiliation.identifier.type
        * OrganizationAffiliation.identifier.value
        * OrganizationAffiliation.location
        * OrganizationAffiliation.network
        * OrganizationAffiliation.organization
        * OrganizationAffiliation.participatingOrganization
        * OrganizationAffiliation.period
        * OrganizationAffiliation.specialty
        * OrganizationAffiliation.telecom
        * OrganizationAffiliation.telecom.rank
        * OrganizationAffiliation.telecom.system
        * OrganizationAffiliation.telecom.value
      )

      id :davinci_plan_net_v110_org_affil_must_support_test

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
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
