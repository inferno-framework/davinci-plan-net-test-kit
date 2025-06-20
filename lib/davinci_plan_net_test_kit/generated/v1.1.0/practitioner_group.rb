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

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
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
of the tests, requiring at least one instance to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of Practitioner 
(e.g., `GET [FHIR Endpoint]/Practitioner`). 
Gathering through this method is controlled by the following inputs (used for all profiles):
- "Use parameterless searches to identify instances?": 
  parameterless searches can be disabled using this input if, for example, 
  the server under test does not support them, or not all instances on the server 
  should be expected to conform to Plan Net profiles. In this case the user **MUST**
  provide specific instance ids to gather.
- "Maximum number of instances to gather using parameterless searches": sets an upper 
  bound on the number of instances Inferno will gather from parameterless searches.
- "Maximum pages of results to consider when using parameterless searches": sets an upper bound 
  on the number of pages of search results Inferno will load when gathering instances 
  using parameterless searches.

### User-provided instance ids

If ids are listed in the "ids of Plan-Net Practitioner instances" optional input, 
they will be read and included at the start of the set of gathered instances.


## Searching
This test sequence will perform a search with each required search parameter
associated with this resource individually. Searches with the
following parameters will be performed:

* name
* _id
* _lastUpdated
* family
* given

### Search Parameters
Each search will look for its parameter values
from the results of the instance gathering step. For example, for a search using
the `identifier` search parameter, the test searches the gathered instances
for one with the `identifier` element populated and then uses that value
as the queried `identifier` value. If a value cannot be found this way, 
the search test is skipped for that search parameter.

### Search Validation
Inferno will retrieve all bundle pages of the reply for
Practitioner resources. Each of the returned instances
is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net Practitioner search for `name=X`
returns a Plan-Net Practitioner instance where `name!=X`



## _revinclude Requirement Testing
This test sequence will perform a search with each required _revinclude search 
parameter associated with this resource. This sequence will perform searches with the
following revincludes:

* PractitionerRole:practitioner

All _revinclude searches will look for candidate ids from the results of 
instance gathering _only_ if tests are ran from the suite level.  Each search 
will use a Plan-Net Practitioner id that is referenced by an instance of the revincluded resource
in the element that is the target of the revinclude search parameter. The returned instances 
are checked to ensure that any 
instances of the revincluded type reference returned instances of the searched resource type.

If running from the group level, inputs of the form 
"Practitioner instance ids referenced in [referencing profile].[referencing element]"
are provided for these tests. Enter ids of the Practitioner profile that
are referenced by the [referencing element] of an instance of the [referencing profile].



## Reverse Chaining Requirement Testing
This test sequence will perform a search with each required combination of reverse chaining 
search parameters, including the following combinations:

* PractitionerRole:practitioner:location
* PractitionerRole:practitioner:network
* PractitionerRole:practitioner:specialty
* PractitionerRole:practitioner:role

All reverse chain searches will look for candidate instances from the results of 
previous tests _only_ if tests are ran from the suite level.  Candidates are 
selected by checking they have both the second (reference element) and third (constraining element) elements
populated. The search value will be taken from the constraining element on the
identified candidate.

If running from the profile level, inputs of the form 
"'[constraining element]' value from a [source resource type] instance with '[reference element]' populated"
are provided for these tests upon test start. Enter a value from the [constraining element] element
of an instance of a [source resource type] resource that also contains a reference to
the tested Practitioner in its [reference element] element. The input will
be used as the search value.

The test will first create and execute a request with the chain parameter.
The test will then perform a search against the [source resource type] with
the [constraining] SeachParameter using the same search value.  Each resource returned in the first
request will then be checked, validating that the ids of those resources are also referenced
by _any_ of the resources returned by the second request in its [reference element] element.



## Profile Validation
Each resource identified during instance gathering and other queries run during this test sequence
is expected to conform to the [Plan-Net Practitioner](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/StructureDefinition/plannet-Practitioner). Each element is checked 
by the HL7 Validator against terminology binding and cardinality requirements. Elements with a 
required binding are validated against their bound ValueSet. If the code/system in the element 
is not part of the ValueSet, then the test will fail.

## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. 
The test will look through the Plan-Net Practitioner instances identified 
during instance gathering and other queries run during this test sequence.
If no populated instance can be found for any must support element, the test 
will fail. 

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :davinci_plan_net_v110_practitioner
      run_as_group
      verifies_requirements 'hl7.fhir.us.davinci-pdex-plan-net_1.1.0@12'

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'practitioner', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_plan_net_v110_practitioner_no_params_search_test
      test from: :davinci_plan_net_v110_practitioner_read_test
      test from: :davinci_plan_net_v110_practitioner_name_search_test
      test from: :davinci_plan_net_v110_practitioner__id_search_test
      test from: :davinci_plan_net_v110_practitioner__lastUpdated_search_test
      test from: :davinci_plan_net_v110_practitioner_family_search_test
      test from: :davinci_plan_net_v110_practitioner_given_search_test
      test from: :davinci_plan_net_v110_revinclude_practitioner_practitioner_role_practitioner_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_location_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_network_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_specialty_search_test
      test from: :davinci_plan_net_v110_practitioner_reverse_chain_practitioner_role_practitioner_role_search_test
      test from: :davinci_plan_net_v110_practitioner_validation_test
      test from: :davinci_plan_net_v110_practitioner_must_support_test
      test from: :davinci_plan_net_v110_practitioner_reference_resolution_test
    end
  end
end
