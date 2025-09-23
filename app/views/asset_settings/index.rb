class Views::AssetSettings::Index < Views::Base
  def initialize(asset_settings:, pagy: nil)
    @asset_settings = asset_settings
    @pagy = pagy
  end

  def view_template
    div(class: "p-2 bg-white") do
      Table do
        TableCaption(class: "mb-3") { "Danh sách hàng hóa sẽ được hiển thị ở đây" } if @asset_settings.empty?
        TableHeader do
          TableRow do
            TableHead { "STT" }
            TableHead { "Lĩnh vực" }
            TableHead { "Tên hàng hóa" }
            TableHead { "Mã" }
            TableHead { "Tiền cầm" }
            TableHead { "Lãi suất" }
            TableHead { "Kỳ lãi" }
            TableHead { "Tình trạng" }
            TableHead { "Chức năng" }
          end
        end
        TableBody do
          @asset_settings.each_with_index do |asset_setting, index|
            TableRow do
              TableCell(class: "font-medium") { @pagy.offset + index + 1 }
              TableCell(class: "font-medium") { asset_setting.fm_contract_types }
              TableCell(class: "font-medium") { asset_setting.asset_name }
              TableCell(class: "font-medium") { asset_setting.asset_code }
              TableCell(class: "font-medium") { asset_setting.default_loan_amount_formatted }
              TableCell(class: "font-medium") { asset_setting.fm_interest_rate }
              TableCell(class: "font-medium") { asset_setting.fm_interest_period }
              TableCell(class: "font-medium") { asset_setting.status_badge }
              TableCell(class: "font-medium") do
                div(class: "flex space-x-2") do
                  a(href: edit_asset_setting_path(asset_setting.id), class: "") do
                    Remix::EditBoxLine(class: "w-5 h-5")
                  end
                  a(href: "#", class: "") do
                    Remix::FileTextLine(class: "w-5 h-5")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
