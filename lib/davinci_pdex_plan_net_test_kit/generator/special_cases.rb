module DaVinciPDEXPlanNetTestKit
  class Generator
    module SpecialCases
      RESOURCES_TO_EXCLUDE = [].freeze

      PROFILES_TO_EXCLUDE = [].freeze

      class << self
        def exclude_group?(group)
          RESOURCES_TO_EXCLUDE.include?(group.resource)
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
