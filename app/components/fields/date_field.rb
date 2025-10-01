class Components::Fields::DateField < Components::Base
  def initialize(label:, value: nil, name: "form[:date_field]", id: "date_field", error: nil, **opts)
    @label = label
    @name = name
    @id = id
    @error = error
    @value = value
    @placeholder = opts[:placeholder]
    @wrapper_class = opts[:wrapper_class] || ""
    @data_attrs = opts[:data] || {}
  end

  def view_template
    FormField(class: @wrapper_class) do
      FormFieldLabel { @label }
      div(class: "space-y-4 mb-0 w-full") do
        Popover(options: { trigger: "click" }) do
          PopoverTrigger(class: "w-full") do
            div(class: "grid w-full items-center gap-1.5") do
              Input(
                name: @name,
                class: "rounded-md border shadow", id: @id,
                placeholder: @placeholder || "dd/mm/yyyy",
                autocomplete: "off",
                value: @value.present? ? @value.to_date.to_fs(:date_vn) : "",
                data_controller: "ruby-ui--calendar-input",
                pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ",
                **@data_attrs,
              )
            end
          end
          PopoverContent do
            Calendar(input_id: "##{@id}")
          end
        end
      end
      FormFieldError() { @error }
    end
  end
end
