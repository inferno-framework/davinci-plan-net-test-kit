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

        def fix_revincludes_for_organization(ig_metadata)
          organization_group = ig_metadata.groups.find { |group| group.name == 'plannet_Organization'}
          network_group = ig_metadata.groups.find { |group| group.name == 'plannet_Network'}

          network_revinclude = organization_group.revincludes.find { |revinclude| revinclude.split(/:/)[1] == "network"}
          corrected_revinclude_list = organization_group.revincludes.dup.delete_if { |revinclude| revinclude.split(/:/)[1] == "network"}
          
          organization_group.revincludes = corrected_revinclude_list
          network_group.revincludes = [network_revinclude]
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
