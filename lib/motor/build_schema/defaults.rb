# frozen_string_literal: true

module Motor
  module BuildSchema
    module Defaults
      module_function

      # rubocop:disable Metrics/MethodLength
      def actions
        [
          {
            name: 'create',
            display_name: I18n.t('motor.create'),
            action_type: BuildSchema::DEFAULT_TYPE,
            preferences: {},
            visible: true
          },
          {
            name: 'edit',
            display_name: I18n.t('motor.edit'),
            action_type: BuildSchema::DEFAULT_TYPE,
            preferences: {},
            visible: true
          },
          {
            name: 'remove',
            display_name: I18n.t('motor.remove'),
            action_type: BuildSchema::DEFAULT_TYPE,
            preferences: {},
            visible: true
          }
        ].freeze
      end
      # rubocop:enable Metrics/MethodLength

      def tabs
        [
          {
            name: 'details',
            display_name: I18n.t('motor.details'),
            tab_type: BuildSchema::DEFAULT_TYPE,
            preferences: {},
            visible: true
          }
        ].freeze
      end
    end
  end
end
