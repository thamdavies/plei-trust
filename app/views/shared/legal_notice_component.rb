class Views::Shared::LegalNoticeComponent < Views::Base
  def view_template
    Card(class: "w-[calc(100%-2rem)] m-4") do
      CardContent do
        p(class: "text-sm text-red-500 font-bold mb-2 mt-4") do
          "Quý khách hàng khi đăng ký và sử dụng phần mềm cam kết:"
        end
        ul(class: "list-disc pl-5 text-sm text-gray-600 space-y-1") do
          li do
            strong(class: "text-gray-900") { "Tuân thủ pháp luật: " }
            plain "Không sử dụng phần mềm cho các hành vi vi phạm pháp luật, trái đạo đức hoặc thuần phong mỹ tục Việt Nam. Lãi suất cho vay ≥100%/năm (tương đương khoảng 0.273%/ngày) là vi phạm pháp luật, có thể bị truy cứu trách nhiệm hình sự theo "
            strong(class: "text-red-500") { "Điều 201 Bộ luật Hình sự" }
            plain ". Quý khách hàng cần đảm bảo lãi suất áp dụng tuân thủ quy định pháp luật, đặc biệt cần tìm hiểu và tuân thủ "
            strong(class: "text-gray-900") { "Điều 468 Bộ Luật Dân Sự 2015" }
            plain " về lãi suất vay"
          end
          li do
            strong(class: "text-gray-900") { "Quản lý tài khoản và trách nhiệm: " }
            plain "Khách hàng cần tìm hiểu, nghiên cứu các quy định của pháp luật có liên quan đến hoạt động kinh doanh của mình hoặc có thể sử dụng các dịch vụ pháp lý để bảo đảm rằng Khách hàng có đầy đủ hiểu biết về ngành nghề mình đang kinh doanh để thực hiện các hành vi phù hợp quy định của pháp luật. Quý Khách Hàng tự chịu trách nhiệm quản lý nội dung, thông tin và hoạt động trên tài khoản. Đảm bảo các thông tin, phí dịch vụ, lãi suất, và mọi hoạt động liên quan tuân thủ pháp luật hiện hành, đồng thời chịu hoàn toàn trách nhiệm về bất kỳ vi phạm nào."
          end
        end
      end
    end
  end
end
