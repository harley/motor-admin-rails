# frozen_string_literal: true

module Motor
  module BuildSchema
    module ApplyPermissions
      module_function

      def call(schema, ability)
        schema.map do |model|
          klass = model[:class_name].constantize

          next unless ability.can?(:read, klass)

          model[:associations] = filter_associations(model[:associations], ability)
          model[:columns] = filter_columns(klass, model[:columns], ability)
          model[:actions] = filter_actions(klass, model[:actions], ability)

          model
        end.compact
      end

      def filter_associations(associations, ability)
        associations.select do |assoc|
          ability.can?(:read, assoc[:model_name].classify.constantize)
        end
      end

      def filter_columns(model, columns, ability)
        columns.map do |column|
          next unless ability.can?(:read, model, column[:name])

          next if column.dig(:reference, :model_name).present? &&
                  !ability.can?(:read, column[:reference][:model_name].classify.constantize)

          unless ability.can?(:update, model, column[:name])
            column = column.merge(access_type: BuildSchema::ColumnAccessTypes::READ_ONLY)
          end

          column
        end.compact
      end

      def filter_actions(model, actions, ability)
        actions.select do |action|
          ability.can?(action[:name].to_sym, model)
        end
      end
    end
  end
end
