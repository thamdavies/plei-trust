# frozen_string_literal: true

module RubyUI
  class SelectTrigger < Base
    def initialize(variant: :default, **attrs)
      @variant = variant
      super(**attrs)
    end

    def view_template(&block)
      button(**attrs) do
        block&.call
        icon
      end
    end

    private

    attr_reader :variant

    def icon
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        class: "ml-2 h-4 w-4 shrink-0 opacity-50",
        stroke_width: "2",
        stroke_linecap: "round",
        stroke_linejoin: "round"
      ) do |s|
        s.path(
          d: "m7 15 5 5 5-5"
        )
        s.path(
          d: "m7 9 5-5 5 5"
        )
      end
    end

    def default_attrs
      {
        data: {
          action: "ruby-ui--select#onClick",
          ruby_ui__select_target: "trigger"
        },
        type: "button",
        role: "combobox",
        aria: {
          controls: "radix-:r0:",
          expanded: "false",
          autocomplete: "none",
          haspopup: "listbox",
          activedescendant: true
        },
        class:
          "truncate w-full flex h-9 cursor-pointer items-center justify-between whitespace-nowrap rounded-md bg-transparent px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none disabled:cursor-not-allowed disabled:opacity-50"
      }
    end

    def ghost_classes
      case variant
      when :ghost
        "bg-transparent text-gray-700 dark:text-gray-400"
      else
        "bg-white text-gray-900 dark:bg-gray-800 dark:text-white"
      end
    end
  end
end
