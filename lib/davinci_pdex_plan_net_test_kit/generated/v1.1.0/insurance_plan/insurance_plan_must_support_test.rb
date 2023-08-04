require_relative '../../../must_support_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanMustSupportTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the InsurancePlan resources returned'
      description %(
        US Core Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the US Core Server Capability
        Statement. This test will look through the InsurancePlan resources
        found previously for the following must support elements:

        * InsurancePlan.administeredBy
        * InsurancePlan.alias
        * InsurancePlan.contact
        * InsurancePlan.contact.name
        * InsurancePlan.contact.name.text
        * InsurancePlan.contact.telecom
        * InsurancePlan.contact.telecom.system
        * InsurancePlan.contact.telecom.value
        * InsurancePlan.coverageArea
        * InsurancePlan.endpoint
        * InsurancePlan.identifier.assigner
        * InsurancePlan.identifier.type
        * InsurancePlan.identifier.value
        * InsurancePlan.name
        * InsurancePlan.network
        * InsurancePlan.ownedBy
        * InsurancePlan.period
        * InsurancePlan.plan.coverageArea
        * InsurancePlan.plan.type
        * InsurancePlan.status
        * InsurancePlan.type
      )

      id :davinci_pdex_plan_net_v110_insurance_plan_must_support_test

      def resource_type
        'InsurancePlan'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:insurance_plan_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
