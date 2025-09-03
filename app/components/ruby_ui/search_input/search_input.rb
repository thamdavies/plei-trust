# frozen_string_literal: true

module RubyUI
  class SearchInput < Base
    def initialize(type: :string, **attrs)
      @type = type.to_sym
      super(**attrs)
    end

    def view_template
      div(class: "relative") do
        div(class: "absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none") do
          PhlexIcons::Remix::SearchLine(class: "w-4 h-4 text-gray-500 dark:text-gray-400")
        end
        input(type: @type, **attrs)
      end
    end

    private

    def default_attrs
      {
        data: {
          ruby_ui__form_field_target: "input",
          action: "input->ruby-ui--form-field#onInput invalid->ruby-ui--form-field#onInvalid"
        },
        class: "flex h-9 w-full rounded-md border bg-background pl-8 pr-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 disabled:cursor-not-allowed disabled:opacity-50 border-border focus-visible:ring-ring placeholder:text-muted-foreground"
      }
    end
  end
end
