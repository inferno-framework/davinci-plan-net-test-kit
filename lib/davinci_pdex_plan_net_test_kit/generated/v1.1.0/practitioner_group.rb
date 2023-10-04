require_relative 'practitioner/practitioner_no_params_search_test'
require_relative 'practitioner/practitioner_read_test'
require_relative 'practitioner/practitioner_name_search_test'
require_relative 'practitioner/practitioner_id_search_test'
require_relative 'practitioner/practitioner_lastupdated_search_test'
require_relative 'practitioner/practitioner_family_search_test'
require_relative 'practitioner/practitioner_given_search_test'
require_relative 'practitioner/practitioner_revinclude_practitioner_role_practitioner_search_test'
require_relative 'practitioner/practitioner_reverse_chain_practitioner_role_practitioner_location_search_test'
require_relative 'practitioner/practitioner_reverse_chain_practitioner_role_practitioner_network_search_test'
require_relative 'practitioner/practitioner_reverse_chain_practitioner_role_practitioner_specialty_search_test'
require_relative 'practitioner/practitioner_reverse_chain_practitioner_role_practitioner_role_search_test'
require_relative 'practitioner/practitioner_validation_test'
require_relative 'practitioner/practitioner_must_support_test'
require_relative 'practitioner/practitioner_reference_resolution_test'

module DaVinciPDEXPlanNetTestKit
  module DaVinciPDEXPlanNetV110
    class PractitionerGroup < Inferno::TestGroup
      title 'Plan-Net Practitioner Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net Practitioner.'
      description %(
  # Background

The Plan-Net Practitioner sequence verifies that the system under test is
able to provide correct responses for Practitioner queries. These queries
must return resources conforming to the Plan-Net Practitioner profile as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology

## Instance Gathering

Inferno will first identify and obtain a set of instances to use for the rest
of the tests, requiring at least one instances to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of Practitioner 
(e.g., `GET [FHIR Endpoint]/Practitioner`). Gathering through this method is controlled 
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

If ids are listed in the _Ids of instances of Plan-Net Practitioner_ optional input field, 
they will be read and included in the set of gathered instances.


## Searching
This test sequence will perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* name
* _id
* _lastUpdated
* family
* given

### Search Parameters
The first search uses the selected Plan-Net Practitioner(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the Plan-Net Practitioner sequence is performed by looking for an existing
`Practitioner.identifier` value from an instance identified during
the instance gathering step. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
Practitioner resources. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net Practitioner search for `name=X`
returns a Plan-Net Practitioner where `name!=X`



## _revinclude Requirement Testing
This test sequence will perform each required _revinclude search associated
with this resource. This sequence will perform searches with the
following includes:

* PractitionerRole:practitioner

All _revinclude searches will look for candidate IDs from the results of 
instance gathering _only_ if tests are ran from the suite level.  Each search 
will use a Plan-Net Practitioner ID that is referenced by an instance of the revincluded resource
and the revinclude parameter. The return is scanned to find any of the expected additional resource.

If running from the profile level, input boxes are provided for these tests upon test start.




## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. If at
least one cannot be found, the test will fail. The test will look
through the Plan-Net Practitioner instances identified during instance gathering
for these elements.

## Profile Validation
Each resource identified during instance gathering is expected to conform to
the [Plan-Net Practitioner](http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Practitioner). Each element is checked against
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

      id :davinci_pdex_plan_net_v110_practitioner
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'practitioner', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_pdex_plan_net_v110_practitioner_no_params_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_read_test
      test from: :davinci_pdex_plan_net_v110_practitioner_name_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner__id_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner__lastUpdated_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_family_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_given_search_test
      test from: :davinci_plan_net_v110_revinclude_practitioner_practitioner_role_practitioner_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_location_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_network_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_specialty_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_role_search_test
      test from: :davinci_pdex_plan_net_v110_practitioner_validation_test
      test from: :davinci_pdex_plan_net_v110_practitioner_must_support_test
      test from: :davinci_pdex_plan_net_v110_practitioner_reference_resolution_test
    end
  end
end
