class Components::Fields::DateField < Components::Base
  def initialize(label:, value: nil, name: "form[:date_field]", id: "date_field", error: nil)
    @label = label
    @name = name
    @id = id
    @error = error
    @value = value
  end

  def view_template
    FormField do
      FormFieldLabel { @label }
      div(class: "space-y-4 mb-0 w-full") do
        Popover(options: { trigger: "click" }) do
          PopoverTrigger(class: "w-full") do
            div(class: "grid w-full items-center gap-1.5") do
              Input(
                name: @name,
                class: "rounded-md border shadow", id: @id,
                placeholder: "Chọn ngày",
                value: @value.present? ? @value.to_date.to_fs(:date_vn) : "",
                data_controller: "ruby-ui--calendar-input",
                pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ"
              )
            end
          end
          PopoverContent do
            Calendar(input_id: "##{@id}", date_format: "dd/MM/yyyy")
          end
        end
      end
      FormFieldError() { @error }
    end
  end
end
