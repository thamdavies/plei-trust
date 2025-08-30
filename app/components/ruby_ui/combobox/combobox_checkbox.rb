# frozen_string_literal: true

module RubyUI
  class ComboboxCheckbox < Base
    def view_template
      input(type: "checkbox", **attrs)
    end

    private

    def default_attrs
      {
        class: [
          "peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background accent-primary",
          "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
          "disabled:cursor-not-allowed disabled:opacity-50"
        ],
        data: {
          ruby_ui__combobox_target: "input",
          action: "ruby-ui--combobox#inputChanged"
        }
      }
    end
  end
end
