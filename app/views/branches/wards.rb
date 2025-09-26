class Views::Branches::Wards < Views::Base
  def initialize(wards:, current_ward_id: nil)
    @wards = wards
    @current_ward_id = current_ward_id
  end

  def view_template
    turbo_frame_tag "ward_list" do
      Combobox do
        ComboboxTrigger placeholder: "Chọn quận huyện"

        ComboboxPopover do
          ComboboxSearchInput(placeholder: "Chọn quận huyện hoặc nhập tên")

          ComboboxList do
            ComboboxEmptyState { "Không tìm thấy" }

            ComboboxListGroup(label: "Danh sách quận huyện") do
              @wards.each do |ward|
                ComboboxItem do
                  ComboboxRadio(
                    name: "form[ward_id]",
                    value: ward.id,
                    checked: ward.id == current_ward_id,
                  )
                  span { ward.name }
                end
              end
            end
          end
        end
      end
    end
  end

  attr_reader :wards, :current_ward_id
end
