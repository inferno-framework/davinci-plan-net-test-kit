module Inferno
  module Repositories
    class InMemoryRepository
      def insert(entity)
        all << entity
        if entity.respond_to? :id
          self.class.hash_with_duplicates[entity.id] << entity
        end
        entity
      end

      def self.hash_with_duplicates
        @hash_with_duplicates ||= Hash.new { |h, k| h[k] = [] }
      end
    end
  end
end

require_relative 'davinci_plan_net_test_kit/generated/v1.1.0/davinci_plan_net_test_suite'
