class Components::Fields::DateField < Components::Base
  def initialize(label:, value: nil, name: "form[:date_field]", id: "date_field", error: nil, **opts)
    @label = label
    @name = name
    @id = id
    @error = error
    @value = value
    @placeholder = opts[:placeholder]
    @readonly = opts[:readonly] || false
    @wrapper_style = opts[:wrapper_style] || ""
    @wrapper_class = opts[:wrapper_class] || ""
    @label_classes = opts[:label_classes] || ""
    @data_attrs = opts[:data] || {}
    @input_actions = opts[:input_actions] || ""
    @listen_change = opts[:listen_change] || false
  end

  def view_template
    if @wrapper_style == :inline
      horizontal_layout
    else
      vertical_layout
    end
  end

  private

  def vertical_layout
    FormField(class: @wrapper_class) do
      FormFieldLabel(class: @label_classes) { @label }
      div(class: "space-y-4 mb-0 w-full") do
        if @readonly
          Input(
            name: @name,
            class: "rounded-md border shadow", id: @id,
            placeholder: @placeholder || "dd/mm/yyyy",
            autocomplete: "off",
            readonly: @readonly,
            value: @value.present? ? @value.to_date.to_fs(:date_vn) : "",
            data_controller: "ruby-ui--calendar-input",
            input_actions: @input_actions,
            pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ",
            **@data_attrs,
          )
        else
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
                  input_actions: @input_actions,
                  pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ",
                  **@data_attrs,
                )
              end
            end

            PopoverContent do
              if @value.present?
                Calendar(input_id: "##{@id}", selected_date: @value.present? ? @value.to_date : "", listen_change: @listen_change)
              else
                Calendar(input_id: "##{@id}", listen_change: @listen_change)
              end
            end
          end
        end
      end
      FormFieldError() { @error }
    end
  end

  def horizontal_layout
    div(class: "flex gap-4 items-center") do
      FormField do
        div(class: "max-w-md flex items-center gap-2 mb-0") do
          FormFieldLabel(class: @label_classes) { @label }
          div(class: "space-y-4 mb-0 w-md") do
            if @readonly
              Input(
                name: @name,
                class: "rounded-md border shadow", id: @id,
                placeholder: @placeholder || "dd/mm/yyyy",
                autocomplete: "off",
                readonly: @readonly,
                value: @value.present? ? @value.to_date.to_fs(:date_vn) : "",
                data_controller: "ruby-ui--calendar-input",
                input_actions: @input_actions,
                pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ",
                **@data_attrs,
              )
            else
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
                      input_actions: @input_actions,
                      pattern: "\\d{2}/\\d{2}/\\d{4}", data_pattern_mismatch: "ngày không hợp lệ",
                      **@data_attrs,
                    )
                  end
                end

                PopoverContent do
                  if @value.present?
                    Calendar(input_id: "##{@id}", selected_date: @value.present? ? @value.to_date : "", listen_change: @listen_change)
                  else
                    Calendar(input_id: "##{@id}", listen_change: @listen_change)
                  end
                end
              end
            end
          end
        end

        FormFieldError() { @error }
      end
    end
  end
end
