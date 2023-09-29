require_relative 'insurance_plan/insurance_plan_no_params_search_test'
require_relative 'insurance_plan/insurance_plan_read_test'
require_relative 'insurance_plan/insurance_plan_administered_by_search_test'
require_relative 'insurance_plan/insurance_plan_owned_by_search_test'
require_relative 'insurance_plan/insurance_plan_coverage_area_search_test'
require_relative 'insurance_plan/insurance_plan_name_search_test'
require_relative 'insurance_plan/insurance_plan_plan_type_search_test'
require_relative 'insurance_plan/insurance_plan_identifier_search_test'
require_relative 'insurance_plan/insurance_plan_id_search_test'
require_relative 'insurance_plan/insurance_plan_lastupdated_search_test'
require_relative 'insurance_plan/insurance_plan_type_search_test'
require_relative 'insurance_plan/insurance_plan_include_insurance_plan_administered_by_search_test'
require_relative 'insurance_plan/insurance_plan_include_insurance_plan_owned_by_search_test'
require_relative 'insurance_plan/insurance_plan_include_insurance_plan_coverage_area_search_test'
require_relative 'insurance_plan/insurance_plan_forward_chain_administered_by_name_search_test'
require_relative 'insurance_plan/insurance_plan_forward_chain_administered_by_partof_search_test'
require_relative 'insurance_plan/insurance_plan_forward_chain_owned_by_name_search_test'
require_relative 'insurance_plan/insurance_plan_forward_chain_owned_by_partof_search_test'
require_relative 'insurance_plan/insurance_plan_validation_test'
require_relative 'insurance_plan/insurance_plan_must_support_test'
require_relative 'insurance_plan/insurance_plan_reference_resolution_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class InsurancePlanGroup < Inferno::TestGroup
      title 'Plan-Net InsurancePlan Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net InsurancePlan.'
      description %(
  # Background

The Plan-Net InsurancePlan sequence verifies that the system under test is
able to provide correct responses for InsurancePlan queries. These queries
must return resources conforming to the Plan-Net InsurancePlan profile as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology

## Instance Gathering

Inferno will first identify and obtain a set of instances to use for the rest
of the tests, requiring at least one instances to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of InsurancePlan 
(e.g., `GET [FHIR Endpoint]/InsurancePlan`). Gathering through this method is controlled 
by the following input fields (used for all profiles):
- _Use parameterless searches to identify instances?_: 
  parameterless searches can be disabled using this input field if, for example, 
  the server under test does not support them, or not all instances on the server 
  should be expected to conform to Plan Net profiles. In this case the user **MUST**
  provide specific instance ids to gather.
- _Maximum number of instances to gather using parameterless searches_: sets an upper 
  bound on the number of instances Inferno will gather from parameterless searches.
- _Maximum pages of results to consider when using parameterless searches_: sets an upper bound 
  on the number of pages of search results Inferno will load when gathering instances 
  using parameterless searches.

### User-provided instance ids

If ids are listed in the _Ids of instances of Plan-Net InsurancePlan_ optional input field, 
they will be read and included in the set of gathered instances.


## Searching
This test sequence will perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* administered-by
* owned-by
* coverage-area
* name
* plan-type
* identifier
* _id
* _lastUpdated
* type

### Search Parameters
The first search uses the selected Plan-Net InsurancePlan(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the Plan-Net InsurancePlan sequence is performed by looking for an existing
`InsurancePlan.identifier` value from an instance identified during
the instance gathering step. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
InsurancePlan resources. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net InsurancePlan search for `administered-by=X`
returns a Plan-Net InsurancePlan where `administered-by!=X`


## _include Requirement Testing
This test sequence will perform each required _include search associated
with this resource. This sequence will perform searches with the
following includes:

* InsurancePlan:administered-by
* InsurancePlan:owned-by
* InsurancePlan:coverage-area

All _include searches will look for candidate IDs from the results of 
instance gathering.  Each search will use a Plan-Net InsurancePlan ID and the include parameter.
The return is scanned to find any of the expected additional resource.



## Forward Chaining Requirement Testing
This test sequence will perform each required forward chaining search for each of 
the search parameters that specify chaining capabilities.  This sequence will perform searches with the
following chaining parameters:

| Search Parameters | Chain Requirements |
| --- | --- |
| administered-by | name, partof |
| owned-by | name, partof |




## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. If at
least one cannot be found, the test will fail. The test will look
through the Plan-Net InsurancePlan instances identified during instance gathering
for these elements.

## Profile Validation
Each resource identified during instance gathering is expected to conform to
the [Plan-Net InsurancePlan](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-InsurancePlan). Each element is checked against
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

      id :davinci_pdex_plan_net_v110_insurance_plan
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'insurance_plan', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_pdex_plan_net_v110_insurance_plan_no_params_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_read_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_administered_by_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_owned_by_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_coverage_area_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_name_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_plan_type_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_identifier_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan__id_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan__lastUpdated_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_type_search_test
      test from: :davinci_plan_net_v110_include_insurance_plan_insurance_plan_administered_by_search_test
      test from: :davinci_plan_net_v110_include_insurance_plan_insurance_plan_owned_by_search_test
      test from: :davinci_plan_net_v110_include_insurance_plan_insurance_plan_coverage_area_search_test
      test from: :davinci_plan_net_v110_forward_chain_administered_by_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_administered_by_partof_search_test
      test from: :davinci_plan_net_v110_forward_chain_owned_by_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_owned_by_partof_search_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_validation_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_must_support_test
      test from: :davinci_pdex_plan_net_v110_insurance_plan_reference_resolution_test
    end
  end
end
