module DaVinciPDEXPlanNetTestKit
  class Generator
    module Naming
      LOCATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-location'
      ORGANIZATION = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization'
      PRACTITIONER = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner'
      PRACTITIONER_ROLE = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole'

      class << self
        def resources_with_multiple_profiles
          ['Organization']
        end

        def resource_has_multiple_profiles?(resource)
          resources_with_multiple_profiles.include? resource
        end

        def snake_case_for_profile(group_metadata)
          resource = group_metadata.resource
          return resource.underscore unless resource_has_multiple_profiles?(resource)

          # Networks and Organizations need to be separated
          case group_metadata.profile_url
          when 'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Network'
            return 'network'
          when 'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Organization'
            return 'organization'
          end
        end

        def upper_camel_case_for_profile(group_metadata)
          snake_case_for_profile(group_metadata).camelize
        end
      end
    end
  end
end
