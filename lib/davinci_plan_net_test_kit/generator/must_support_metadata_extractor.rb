require_relative 'must_support_metadata_extractor_us_core_3'
require 'inferno'

module DaVinciPlanNetTestKit
  class Generator
    class MustSupportMetadataExtractor < Inferno::DSL::MustSupportMetadataExtractor
      def must_supports
        @must_supports = super

        handle_special_cases

        @must_supports
      end

      #### SPECIAL CASE ####

      def handle_special_cases

        case profile.version
        when '1.1.0'
          MustSupportMetadataExtractorUsCore3.new(profile, @must_supports).handle_special_cases
        end
      end

      # ONC and US Core 4.0.0 both clarified that health IT developers that always provide HL7 FHIR "observation" values
      # are not required to demonstrate Health IT Module support for "dataAbsentReason" elements.
      # Remove MS check for dataAbsentReason and component.dataAbsentReason from vital sign profiles and observation lab profile
      # Smoking status profile does not have MS on dataAbsentReason. It is safe to use profile.type == 'Observation'
      def remove_observation_data_absent_reason
        if profile.type == 'Observation'
          @must_supports[:elements].delete_if do |element|
            ['dataAbsentReason', 'component.dataAbsentReason'].include?(element[:path])
          end
        end
      end
    end
  end
end
