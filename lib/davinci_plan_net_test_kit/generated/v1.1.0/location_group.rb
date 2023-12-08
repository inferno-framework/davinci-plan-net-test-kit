require_relative 'location/location_no_params_search_test'
require_relative 'location/location_read_test'
require_relative 'location/location_partof_search_test'
require_relative 'location/location_organization_search_test'
require_relative 'location/location_endpoint_search_test'
require_relative 'location/location_address_city_search_test'
require_relative 'location/location_address_state_search_test'
require_relative 'location/location_address_postalcode_search_test'
require_relative 'location/location_address_search_test'
require_relative 'location/location_type_search_test'
require_relative 'location/location_id_search_test'
require_relative 'location/location_lastupdated_search_test'
require_relative 'location/location_include_location_endpoint_search_test'
require_relative 'location/location_include_location_organization_search_test'
require_relative 'location/location_include_location_partof_search_test'
require_relative 'location/location_revinclude_healthcare_service_location_search_test'
require_relative 'location/location_revinclude_insurance_plan_coverage_area_search_test'
require_relative 'location/location_revinclude_organization_affiliation_location_search_test'
require_relative 'location/location_revinclude_practitioner_role_location_search_test'
require_relative 'location/location_forward_chain_partof_type_search_test'
require_relative 'location/location_forward_chain_partof_address_search_test'
require_relative 'location/location_forward_chain_partof_organization_search_test'
require_relative 'location/location_forward_chain_organization_name_search_test'
require_relative 'location/location_forward_chain_organization_address_search_test'
require_relative 'location/location_forward_chain_organization_partof_search_test'
require_relative 'location/location_forward_chain_organization_type_search_test'
require_relative 'location/location_forward_chain_endpoint_organization_search_test'
require_relative 'location/location_reverse_chain_insurance_plan_coverage_area_owned_by_search_test'
require_relative 'location/location_validation_test'
require_relative 'location/location_must_support_test'
require_relative 'location/location_reference_resolution_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class LocationGroup < Inferno::TestGroup
      title 'Plan-Net Location Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net Location.'
      description %(
  # Background

The Plan-Net Location sequence verifies that the system under test is
able to provide correct responses for Location queries. These queries
must return resources conforming to the Plan-Net Location profile as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology

## Instance Gathering

Inferno will first identify and obtain a set of instances to use for the rest
of the tests, requiring at least one instance to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of Location 
(e.g., `GET [FHIR Endpoint]/Location`). 
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

If ids are listed in the "ids of Plan-Net Location instances" optional input, 
they will be read and included at the start of the set of gathered instances.


## Searching
This test sequence will perform a search with each required search parameter
associated with this resource individually. Searches with the
following parameters will be performed:

* partof
* organization
* endpoint
* address-city
* address-state
* address-postalcode
* address
* type
* _id
* _lastUpdated

### Search Parameters
Each search will look for its parameter values
from the results of the instance gathering step. For example, for a search using
the `identifier` search parameter, the test searches the gathered instances
for one with the `identifier` element populated and then uses that value
as the queried `identifier` value. If a value cannot be found this way, 
the search test is skipped for that search parameter.

### Search Validation
Inferno will retrieve all bundle pages of the reply for
Location resources. Each of the returned instances
is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net Location search for `partof=X`
returns a Plan-Net Location instance where `partof!=X`


## _include Requirement Testing
This test sequence will perform a search with each required _include search 
parameter associated with this profile. This sequence will perform searches with the
following includes:

* Location:endpoint
* Location:organization
* Location:partof

Each _include searches will look for a candidate id that has the target reference element
populated from the results of instance gathering.  Each search will use the identified 
Plan-Net Location id and the include parameter.
The returned instances are checked to ensure that any instances of the included
type are referenced by returned instances of the searched resource type.


## _revinclude Requirement Testing
This test sequence will perform a search with each required _revinclude search 
parameter associated with this resource. This sequence will perform searches with the
following revincludes:

* HealthcareService:location
* InsurancePlan:coverage-area
* OrganizationAffiliation:location
* PractitionerRole:location

All _revinclude searches will look for candidate ids from the results of 
instance gathering _only_ if tests are ran from the suite level.  Each search 
will use a Plan-Net Location id that is referenced by an instance of the revincluded resource
in the element that is the target of the revinclude search parameter. The returned instances 
are checked to ensure that any 
instances of the revincluded type reference returned instances of the searched resource type.

If running from the group level, inputs of the form 
"Location instance ids referenced in [referencing profile].[referencing element]"
are provided for these tests. Enter ids of the Location profile that
are referenced by the [referencing element] of an instance of the [referencing profile].


## Forward Chaining Requirement Testing
This test sequence will perform a search with each required combination of forward chaining 
search parameters. This sequence will perform searches with the following chaining parameters:

| Search Parameters | Chain Requirements |
| :---: | :---: |
| partof | type, address, organization |
| organization | name, address, partof, type |
| endpoint | organization |


All forward chain searches will look for candidate instances of the resource being chained through
from the results of previously run _include tests.  Candidates are chosen from previously returned
instances that have the chain parameter element filled.  Each search test will use one of these values
to build the requests for the test.  The test will be skipped if no candidates can be found.

The test will first create and execute the forward chaining request.
The test will then perform a basic search test on the resource being chained through,
using the same value in the previous request.  Each resource returned in the first
request will then be checked, validating that the element being chained through is populated by
the id of _any_ of the resources returned by the second request.


## Reverse Chaining Requirement Testing
This test sequence will perform a search with each required combination of reverse chaining 
search parameters, including the following combinations:

* InsurancePlan:coverage-area:owned-by

All reverse chain searches will look for candidate instances from the results of 
previous tests _only_ if tests are ran from the suite level.  Candidates are 
selected by checking they have both the second (reference element) and third (constraining element) elements
populated. The search value will be taken from the constraining element on the
identified candidate.

If running from the profile level, inputs of the form 
"'[constraining element]' value from a [source resource type] instance with '[reference element]' populated"
are provided for these tests upon test start. Enter a value from the [constraining element] element
of an instance of a [source resource type] resource that also contains a reference to
the tested Location in its [reference element] element. The input will
be used as the search value.

The test will first create and execute a request with the chain parameter.
The test will then perform a search against the [source resource type] with
the [constraining] SeachParameter using the same search value.  Each resource returned in the first
request will then be checked, validating that the id of those resources is also referenced
by _any_ of the resources returned by the second request in its [reference element] element.



## Profile Validation
Each resource identified during instance gathering and other queries run during this test sequence
is expected to conform to the [Plan-Net Location](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/StructureDefinition/plannet-Location). Each element is checked 
by the HL7 Validator against terminology binding and cardinality requirements. Elements with a 
required binding are validated against their bound ValueSet. If the code/system in the element 
is not part of the ValueSet, then the test will fail.

## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. 
The test will look through the Plan-Net Location instances identified 
during instance gathering and other queries run during this test sequence.
If no populated instance can be found for any must support element, the test 
will fail. 

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :davinci_plan_net_v110_location
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'location', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_plan_net_v110_location_no_params_search_test
      test from: :davinci_plan_net_v110_location_read_test
      test from: :davinci_plan_net_v110_location_partof_search_test
      test from: :davinci_plan_net_v110_location_organization_search_test
      test from: :davinci_plan_net_v110_location_endpoint_search_test
      test from: :davinci_plan_net_v110_location_address_city_search_test
      test from: :davinci_plan_net_v110_location_address_state_search_test
      test from: :davinci_plan_net_v110_location_address_postalcode_search_test
      test from: :davinci_plan_net_v110_location_address_search_test
      test from: :davinci_plan_net_v110_location_type_search_test
      test from: :davinci_plan_net_v110_location__id_search_test
      test from: :davinci_plan_net_v110_location__lastUpdated_search_test
      test from: :davinci_plan_net_v110_include_location_location_endpoint_search_test
      test from: :davinci_plan_net_v110_include_location_location_organization_search_test
      test from: :davinci_plan_net_v110_include_location_location_partof_search_test
      test from: :davinci_plan_net_v110_revinclude_location_healthcare_service_location_search_test
      test from: :davinci_plan_net_v110_revinclude_location_insurance_plan_coverage_area_search_test
      test from: :davinci_plan_net_v110_revinclude_location_organization_affiliation_location_search_test
      test from: :davinci_plan_net_v110_revinclude_location_practitioner_role_location_search_test
      test from: :davinci_plan_net_v110_forward_chain_partof_type_search_test
      test from: :davinci_plan_net_v110_forward_chain_partof_address_search_test
      test from: :davinci_plan_net_v110_forward_chain_partof_organization_search_test
      test from: :davinci_plan_net_v110_forward_chain_organization_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_organization_address_search_test
      test from: :davinci_plan_net_v110_forward_chain_organization_partof_search_test
      test from: :davinci_plan_net_v110_forward_chain_organization_type_search_test
      test from: :davinci_plan_net_v110_forward_chain_endpoint_organization_search_test
      test from: :davinci_plan_net_v110_location_reverse_chain_insurance_plan_coverage_area_owned_by_search_test
      test from: :davinci_plan_net_v110_location_validation_test
      test from: :davinci_plan_net_v110_location_must_support_test
      test from: :davinci_plan_net_v110_location_reference_resolution_test
    end
  end
end
