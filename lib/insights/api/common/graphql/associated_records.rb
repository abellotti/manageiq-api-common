require "query_relation"

module Insights
  module API
    module Common
      module GraphQL
        class AssociatedRecords
          include Enumerable
          include QueryRelation::Queryable

          def initialize(collection)
            @collection = collection
          end

          private

          def search(mode, options)
            res = filter_collection_by_options(options)

            case mode
            when :first then res.first
            when :last  then res.last
            when :all   then res
            end
          end

          def filter_collection_by_options(options)
            res = @collection
            if options[:where].present?
              options[:where].each_pair { |k, v| res = res.select { |rec| rec[k].to_s == v.to_s } }
            end
            if options[:order].present?
              order_by = options[:order].first
              res = res.sort_by { |rec| rec[order_by] }
            end
            res = res.drop(options[:offset]) if options[:offset]
            res = res.take(options[:limit])  if options[:limit]
            res
          end
        end
      end
    end
  end
end
