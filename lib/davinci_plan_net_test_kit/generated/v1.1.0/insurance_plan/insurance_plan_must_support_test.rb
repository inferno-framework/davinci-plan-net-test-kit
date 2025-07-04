require_relative '../../../must_support_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class InsurancePlanMustSupportTest < Inferno::Test
      include DaVinciPlanNetTestKit::MustSupportTest

      title 'All must support elements are provided in the InsurancePlan resources returned'
      description %(
        Plan Net Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the Plan Net Server Capability
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

      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@3'

      id :davinci_plan_net_v110_insurance_plan_must_support_test

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
