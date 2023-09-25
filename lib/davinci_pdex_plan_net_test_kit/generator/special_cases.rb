module DaVinciPDEXPlanNetTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = [].freeze

      PROFILES_TO_EXCLUDE = [].freeze

      GROUP_SORT_ORDER = ["plannet_Endpoint", 
                          "plannet_InsurancePlan", 
                          "plannet_OrganizationAffiliation",
                          "plannet_PractitionerRole",
                          "plannet_Practitioner",
                          "plannet_HealthcareService",
                          "plannet_Location",
                          "plannet_Network",
                          "plannet_Organization"].freeze

      PARAMETERLESS_FILTER_DESCRIPTION = {
        "Plan-Net Network" => "In order to gather only Organization instances expected to conform to the Plan-Net Network profile, instances where `type` does not equal `ntwk` will be discarded. ",
        "Plan-Net Organization" => "In order to gather only Organization instances expected to conform to the Plan-Net Organization profile, instances where `type` equals `ntwk` will be discarded. "
      }.freeze

      class << self
        def exclude_group?(group)
          RESOURCES_TO_EXCLUDE.include?(group.resource)
        end

        def group_index(group_name)
          GROUP_SORT_ORDER.index(group_name)
        end

        def has_explicit_group_order()
          GROUP_SORT_ORDER.size > 0
        end

        def has_parameterless_filter?(profile_name)
          PARAMETERLESS_FILTER_DESCRIPTION.key?(profile_name)
        end

        def parameterless_filter_description(profile_name)
          PARAMETERLESS_FILTER_DESCRIPTION[profile_name]
        end

        def run_special_cases(ig_metadata)
          fix_network_must_support(ig_metadata)
          fix_revincludes_for_organization(ig_metadata)
        end

        def fix_network_must_support(ig_metadata)
          # The Network profile is based on USCore Organization, since there was no contradiction between the USCore profile 
          # and the Plan-Net requirements. However, the NPI and CLIA identifier types, which are Must-Support, are clearly 
          # intended for provider organizations only and are not expected to be populated for other organization types.
          network_group = ig_metadata.groups.find { |group| group.name == 'plannet_Network'}
          adjusted_must_supports = network_group.must_supports[:slices].dup.delete_if {|slice| slice[:name] == 'Organization.identifier:NPI'}
          network_group.must_supports[:slices] = adjusted_must_supports
        end

        def fix_revincludes_for_organization(ig_metadata)
          # Revincludes are listed in the capability statement at the resource level,
          # but resources that support multiple profiles do not make the distinction of which tests are for which
          # This separates the revinclude lists for Network and Organization profiles from the Organization resource 
          # For Plan Net PDEX v1.1.0
          organization_group = ig_metadata.groups.find { |group| group.name == 'plannet_Organization'}
          network_group = ig_metadata.groups.find { |group| group.name == 'plannet_Network'}

          network_revincludes, corrected_revinclude_list = organization_group.revincludes.partition do |revinclude|
            revinclude.split(/:/)[1] == "network"
          end
          
          organization_group.revincludes = corrected_revinclude_list
          network_group.revincludes = network_revincludes
        end
      end
    end
  end
  
  module SpecialCases
    def self.filter_instance_for_parameterless_gathering?(profile_url, instance)
      case profile_url
      when 'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Organization'
        # filter if we see the network type
        instance.type.reduce(false) { |outer_result, a_type| outer_result || a_type.coding.reduce(false) { |result, a_coding| result || (a_coding.code == 'ntwk' && a_coding.system == 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS') } }
      when 'http://hl7.org/fhir/us/davinci-pdex-plan-net/StructureDefinition/plannet-Network'
        # filter unless we see the network type
        instance.type.reduce(true) { |outer_result, a_type| outer_result && a_type.coding.reduce(true) { |result, a_coding| result && !(a_coding.code == 'ntwk' && a_coding.system == 'http://hl7.org/fhir/us/davinci-pdex-plan-net/CodeSystem/OrgTypeCS') } }
      else
        false
      end
    end
  end

end
