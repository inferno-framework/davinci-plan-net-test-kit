require_relative 'practitioner_role/practitioner_role_no_params_search_test'
require_relative 'practitioner_role/practitioner_role_read_test'
require_relative 'practitioner_role/practitioner_role_practitioner_search_test'
require_relative 'practitioner_role/practitioner_role_organization_search_test'
require_relative 'practitioner_role/practitioner_role_location_search_test'
require_relative 'practitioner_role/practitioner_role_service_search_test'
require_relative 'practitioner_role/practitioner_role_network_search_test'
require_relative 'practitioner_role/practitioner_role_endpoint_search_test'
require_relative 'practitioner_role/practitioner_role_role_search_test'
require_relative 'practitioner_role/practitioner_role_specialty_search_test'
require_relative 'practitioner_role/practitioner_role_id_search_test'
require_relative 'practitioner_role/practitioner_role_lastupdated_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_practitioner_include_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_organization_include_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_location_include_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_service_include_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_network_include_search_test'
require_relative 'practitioner_role/practitioner_role_practitioner_role_endpoint_include_search_test'
require_relative 'practitioner_role/practitioner_role_validation_test'
require_relative 'practitioner_role/practitioner_role_must_support_test'
require_relative 'practitioner_role/practitioner_role_reference_resolution_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerRoleGroup < Inferno::TestGroup
      title 'Plan-Net PractitionerRole Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net PractitionerRole.'
      description %(
  # Background

The Plan-Net PractitionerRole sequence verifies that the system under test is
able to provide correct responses for PractitionerRole queries. These queries
must contain resources conforming to the Plan-Net PractitionerRole as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* practitioner
* organization
* location
* service
* network
* endpoint
* role
* specialty
* _id
* _lastUpdated

### Search Parameters
The first search uses the selected Plan-Net PractitionerRole(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the Plan-Net PractitionerRole sequence is performed by looking for an existing
`PractitionerRole.identifier` from any of the Plan-Net PractitionerRoles returned in the `_id`
search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
PractitionerRole resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net PractitionerRole search for `practitioner=X``
returns a Plan-Net PractitionerRole where `practitioner!=X`


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the PractitionerRole resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [Plan-Net PractitionerRole](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-PractitionerRole). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :davinci_pdex_plan_net_v110_practitioner_role
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'practitioner_role', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_pdex_plan_net_v110_practitioner_role_no_params_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_read_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_practitioner_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_organization_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_location_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_service_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_network_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_endpoint_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_role_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_specialty_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role__id_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role__lastUpdated_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_practitioner_include_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_organization_include_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_location_include_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_service_include_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_network_include_search_test
      test from: :davinci_plan_net_v110_practitioner_role_practitioner_role_endpoint_include_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_validation_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_must_support_test
      test from: :davinci_pdex_plan_net_v110_practitioner_role_reference_resolution_test
    end
  end
end