require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class OrganizationAffiliationNoParamsSearchTest < Inferno::Test
      include DaVinciPDEXPlanNetTestKit::SearchTest

      title 'Client can identify instances of Plan-Net OrganizationAffiliation on the server'
      description %(
This test gathers instances expected to conform to the target profile
for use in the rest of the tests in this sequence. It will perform
an unparameterized search and/or read instance ids provided by the tester
as described in the "Instance Gathering" section of the group description above.

      )

      id :davinci_pdex_plan_net_v110_organization_affiliation_no_params_search_test

      input :davinci_pdex_plan_net_v110_organization_affiliation_no_params_search_test_ids,
        title: 'ids of Plan-Net OrganizationAffiliation instances',
        optional: true,
        description: 'Required if parameterless searches are not being used for instance gathering.'
      input :no_param_search
      input :max_instances
      input :max_pages

      def self.properties
        @properties ||= SearchTestProperties.new(
          first_search: true,
        resource_type: 'OrganizationAffiliation',
        test_post_search: false
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:organization_affiliation_resources] ||= {}
      end

      run do
        run_search_no_params_test(davinci_pdex_plan_net_v110_organization_affiliation_no_params_search_test_ids)
      end
    end
  end
end
