# frozen_string_literal: true
module Polaris
  module TextField
    class Component < Polaris::Component
      include ActionHelper

      with_content_areas :connected_left, :connected_right

      validates :label_action, type: Action, allow_nil: true
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :label_action, :index

      def initialize(
        form:,
        attribute:,
        placeholder: "",
        type: "text",
        align: "",
        error: "",
        label: nil,
        label_action: nil,
        label_hidden: false,
        multiline: false,
        help_text: "",
        disabled: false,
        index: nil,
        step: 1,
        prefix: nil,
        suffix: nil,
        max: 1_000_000,
        min: 0,
        value: nil,
        monospaced: false,
        **args
      )
        super
        @placeholder = placeholder
        @type = type
        @form = form
        @align = align
        @attribute = attribute
        @error = error
        @label = label
        @label_action = label_action
        @label_hidden = label_hidden
        @multiline = multiline
        @help_text = help_text
        @disabled = disabled
        @index = index
        @step = step
        @prefix = prefix
        @suffix = suffix
        @max = max
        @min = min
        @value = value
        @monospaced = monospaced
      end

      def labelled_attrs
        {
          form: @form,
          attribute: @attribute,
          error: @error,
          label: @label,
          label_hidden: @label_hidden,
          help_text: @help_text,
          index: @index,
          action: @label_action
        }
      end

      def input
        return 'number_field' if number?

        @multiline ? "text_area" : "text_field"
      end

      def number?
        @type == 'number' && @step != 0
      end

      def input_attrs
        attrs = {
          placeholder: @placeholder,
          rows: @multiline || nil,
          disabled: @disabled,
        }

        input_class = "Polaris-TextField__Input"
        input_class += " Polaris-TextField__Input--align#{@align.capitalize}" if @align.present?
        input_class += " Polaris-TextField__Input--suffixed" if @suffix.present?
        input_class += " Polaris-TextField--monospaced" if @monospaced

        attrs[:class] = input_class

        if @index.present?
          attrs[:index] = @index
        end

        if number?
          attrs[:step] = @step
          attrs[:min] = @min
          attrs[:max] = @max

          attrs[:data] = {
            "polaris--text-field-target": "input",
            "action": "input->polaris--text-field#handleInput"
          }
        end

        if @value.present?
          attrs[:value] = @value
        end

        attrs
      end

      private

        def additional_data
          return {} unless number?

          {
            "controller": "polaris--text-field",
            "polaris--text-field-min-value": @min,
            "polaris--text-field-max-value": @max,
            "polaris--text-field-value-value": @value,
          }
        end

        def classes
          classes = ['Polaris-TextField']

          classes << 'Polaris-TextField--hasValue' if @value.present?
          classes << 'Polaris-TextField--error' if @error.present?
          classes << 'Polaris-TextField--disabled' if @disabled

          classes
        end
    end
  end
end
