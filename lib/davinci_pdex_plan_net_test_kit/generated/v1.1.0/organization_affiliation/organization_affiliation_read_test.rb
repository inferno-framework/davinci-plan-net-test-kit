require_relative '../../../read_test'

module DaVinciPDEXPlanNetTestKit
  module USCoreV110
    class OrganizationAffiliationReadTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::ReadTest

      title 'Server returns correct OrganizationAffiliation resource from OrganizationAffiliation read interaction'
      description 'A server SHALL support the OrganizationAffiliation read interaction.'

      id :us_core_v110_organization_affiliation_read_test

      def resource_type
        'OrganizationAffiliation'
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'OrganizationAffiliation'))
      end
    end
  end
end
