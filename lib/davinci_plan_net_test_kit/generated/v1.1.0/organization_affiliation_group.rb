require_relative 'organization_affiliation/organization_affiliation_no_params_search_test'
require_relative 'organization_affiliation/organization_affiliation_read_test'
require_relative 'organization_affiliation/organization_affiliation_primary_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_participating_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_location_search_test'
require_relative 'organization_affiliation/organization_affiliation_service_search_test'
require_relative 'organization_affiliation/organization_affiliation_network_search_test'
require_relative 'organization_affiliation/organization_affiliation_endpoint_search_test'
require_relative 'organization_affiliation/organization_affiliation_role_search_test'
require_relative 'organization_affiliation/organization_affiliation_specialty_search_test'
require_relative 'organization_affiliation/organization_affiliation_id_search_test'
require_relative 'organization_affiliation/organization_affiliation_lastupdated_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_primary_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_participating_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_location_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_service_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_endpoint_search_test'
require_relative 'organization_affiliation/organization_affiliation_include_organization_affiliation_network_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_primary_organization_type_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_primary_organization_address_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_primary_organization_name_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_primary_organization_partof_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_participating_organization_type_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_participating_organization_address_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_participating_organization_name_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_participating_organization_partof_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_address_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_address_postalcode_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_address_city_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_address_state_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_location_type_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_service_service_category_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_service_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_service_location_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_network_name_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_network_partof_search_test'
require_relative 'organization_affiliation/organization_affiliation_forward_chain_endpoint_organization_search_test'
require_relative 'organization_affiliation/organization_affiliation_validation_test'
require_relative 'organization_affiliation/organization_affiliation_must_support_test'
require_relative 'organization_affiliation/organization_affiliation_reference_resolution_test'

module DaVinciPlanNetTestKit
  module DaVinciPlanNetV110
    class OrganizationAffiliationGroup < Inferno::TestGroup
      title 'Plan-Net OrganizationAffiliation Tests'
      short_description 'Verify support for the server capabilities required by the Plan-Net OrganizationAffiliation.'
      description %(
  # Background

The Plan-Net OrganizationAffiliation sequence verifies that the system under test is
able to provide correct responses for OrganizationAffiliation queries. These queries
must return resources conforming to the Plan-Net OrganizationAffiliation profile as
specified in the Plan Net v1.1.0 Implementation Guide.

# Testing Methodology

## Instance Gathering

Inferno will first identify and obtain a set of instances to use for the rest
of the tests, requiring at least one instance to be identified for the test to pass. 
Instances to gather are indentified in two ways. One or both will be used,
depending on user input.

### Parameterless searches 
Instances can be gathered using a query requesting all instances of OrganizationAffiliation 
(e.g., `GET [FHIR Endpoint]/OrganizationAffiliation`). 
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

If ids are listed in the "ids of Plan-Net OrganizationAffiliation instances" optional input, 
they will be read and included at the start of the set of gathered instances.


## Searching
This test sequence will perform a search with each required search parameter
associated with this resource individually. Searches with the
following parameters will be performed:

* primary-organization
* participating-organization
* location
* service
* network
* endpoint
* role
* specialty
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
OrganizationAffiliation resources. Each of the returned instances
is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Plan-Net OrganizationAffiliation search for `primary-organization=X`
returns a Plan-Net OrganizationAffiliation instance where `primary-organization!=X`


## _include Requirement Testing
This test sequence will perform a search with each required _include search 
parameter associated with this profile. This sequence will perform searches with the
following includes:

* OrganizationAffiliation:primary-organization
* OrganizationAffiliation:participating-organization
* OrganizationAffiliation:location
* OrganizationAffiliation:service
* OrganizationAffiliation:endpoint
* OrganizationAffiliation:network

Each _include searches will look for a candidate id that has the target reference element
populated from the results of instance gathering.  Each search will use the identified 
Plan-Net OrganizationAffiliation id and the include parameter.
The returned instances are checked to ensure that any instances of the included
type are referenced by returned instances of the searched resource type.



## Forward Chaining Requirement Testing
This test sequence will perform a search with each required combination of forward chaining 
search parameters. This sequence will perform searches with the following chaining parameters:

| Search Parameters | Chain Requirements |
| :---: | :---: |
| primary-organization | type, address, name, partof |
| participating-organization | type, address, name, partof |
| location | address, address-postalcode, address-city, address-state, organization, type |
| service | service-category, organization, location |
| network | name, partof |
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




## Profile Validation
Each resource identified during instance gathering and other queries run during this test sequence
is expected to conform to the [Plan-Net OrganizationAffiliation](http://hl7.org/fhir/us/davinci-pdex-plan-net/STU1.1/StructureDefinition/plannet-OrganizationAffiliation). Each element is checked 
by the HL7 Validator against terminology binding and cardinality requirements. Elements with a 
required binding are validated against their bound ValueSet. If the code/system in the element 
is not part of the ValueSet, then the test will fail.

## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements populated at least once. 
The test will look through the Plan-Net OrganizationAffiliation instances identified 
during instance gathering and other queries run during this test sequence.
If no populated instance can be found for any must support element, the test 
will fail. 

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :davinci_plan_net_v110_organization_affiliation
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'organization_affiliation', 'metadata.yml'), aliases: true))
      end
  
      test from: :davinci_plan_net_v110_organization_affiliation_no_params_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_read_test
      test from: :davinci_plan_net_v110_organization_affiliation_primary_organization_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_participating_organization_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_location_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_service_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_network_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_endpoint_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_role_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_specialty_search_test
      test from: :davinci_plan_net_v110_organization_affiliation__id_search_test
      test from: :davinci_plan_net_v110_organization_affiliation__lastUpdated_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_primary_organization_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_participating_organization_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_location_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_service_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_endpoint_search_test
      test from: :davinci_plan_net_v110_include_organization_affiliation_organization_affiliation_network_search_test
      test from: :davinci_plan_net_v110_forward_chain_primary_organization_type_search_test
      test from: :davinci_plan_net_v110_forward_chain_primary_organization_address_search_test
      test from: :davinci_plan_net_v110_forward_chain_primary_organization_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_primary_organization_partof_search_test
      test from: :davinci_plan_net_v110_forward_chain_participating_organization_type_search_test
      test from: :davinci_plan_net_v110_forward_chain_participating_organization_address_search_test
      test from: :davinci_plan_net_v110_forward_chain_participating_organization_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_participating_organization_partof_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_address_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_address_postalcode_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_address_city_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_address_state_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_organization_search_test
      test from: :davinci_plan_net_v110_forward_chain_location_type_search_test
      test from: :davinci_plan_net_v110_forward_chain_service_service_category_search_test
      test from: :davinci_plan_net_v110_forward_chain_service_organization_search_test
      test from: :davinci_plan_net_v110_forward_chain_service_location_search_test
      test from: :davinci_plan_net_v110_forward_chain_network_name_search_test
      test from: :davinci_plan_net_v110_forward_chain_network_partof_search_test
      test from: :davinci_plan_net_v110_forward_chain_endpoint_organization_search_test
      test from: :davinci_plan_net_v110_organization_affiliation_validation_test
      test from: :davinci_plan_net_v110_organization_affiliation_must_support_test
      test from: :davinci_plan_net_v110_organization_affiliation_reference_resolution_test
    end
  end
end
