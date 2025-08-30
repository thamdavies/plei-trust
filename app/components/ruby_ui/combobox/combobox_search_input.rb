# frozen_string_literal: true

module RubyUI
  class ComboboxSearchInput < Base
    def initialize(placeholder:, **)
      @placeholder = placeholder
      super(**)
    end

    def view_template
      div class: "flex text-muted-foreground items-center border-b px-3" do
        icon
        input(**attrs)
      end
    end

    private

    def default_attrs
      {
        type: "search",
        class: "flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-none border-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50",
        role: "searchbox",
        placeholder: @placeholder,
        data: {
          ruby_ui__combobox_target: "searchInput",
          action: "keyup->ruby-ui--combobox#filterItems search->ruby-ui--combobox#filterItems"
        },
        autocomplete: "off",
        autocorrect: "off",
        spellcheck: "false"
      }
    end

    def icon
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        class: "mr-2 h-4 w-4 shrink-0 opacity-50",
        stroke_width: "2",
        stroke_linecap: "round",
        stroke_linejoin: "round"
      ) do |s|
        s.circle(cx: "11", cy: "11", r: "8")
        s.path(
          d: "m21 21-4.3-4.3"
        )
      end
    end
  end
end
