module DaVinciPDEXPlanNetTestKit
  class Generator
    class MustSupportMetadataExtractorUsCore3
      attr_accessor :profile, :must_supports

      def initialize(profile, must_supports)
        self.profile = profile
        self.must_supports = must_supports
      end

      def handle_special_cases
        add_must_support_choices
      end

      def add_must_support_choices
        choices = []
          # fill with Plan Net add_must_support_choices

        must_supports[:choices] = choices if choices.present?
      end

      
    end
  end
end