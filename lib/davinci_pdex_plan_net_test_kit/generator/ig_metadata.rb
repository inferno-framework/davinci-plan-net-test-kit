require_relative 'special_cases'

module DaVinciPDEXPlanNetTestKit
  class Generator
    class IGMetadata
      attr_accessor :ig_version, :groups

      def reformatted_version
        @reformatted_version ||= ig_version.delete('.').gsub('-', '_')
      end

      def ordered_groups
        
        if SpecialCases.has_explicit_group_order()
          @ordered_groups ||=
            groups.sort_by { |group| SpecialCases.group_index(group.name) }
        else
          @ordered_groups ||=
            non_delayed_groups + delayed_groups
        end
      end

      def delayed_groups
        @delayed_groups ||=
          groups.select { |group| group.delayed? }
      end

      def non_delayed_groups
        @non_delayed_groups ||=
          groups.reject { |group| group.delayed? }
      end

      def delayed_profiles
        @delayed_profiles ||=
          delayed_groups.map(&:profile_url)
      end

      def postprocess_groups(ig_resources)
        groups.each do |group|
          group.add_delayed_references(delayed_profiles, ig_resources)
        end
      end

      def to_hash
        {
          ig_version: ig_version,
          groups: groups.map(&:to_hash)
        }
      end
    end
  end
end
