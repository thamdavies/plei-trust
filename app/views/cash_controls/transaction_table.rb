class Views::CashControls::TransactionTable < Views::Base
  def initialize(transactions: [])
    @transactions = transactions
  end

  def view_template
    Card do
      CardHeader do
        CardTitle { "Lịch sử nhập quỹ tiền đầu ngày" }
      end
      CardContent do
        Table do
          TableHeader do
            TableRow do
              TableHead { "STT" }
              TableHead { "Ngày" }
              TableHead { "Người giao dịch" }
              TableHead { "Số tiền" }
              TableHead { "Hoạt động" }
            end
          end
          TableBody do
            if @transactions.blank?
              TableRow do
                TableCell(colspan: 4, class: "text-center text-muted-foreground") { "Chưa có giao dịch nào" }
              end
            else
              @transactions.each_with_index do |transaction, index|
                TableRow do
                  TableCell { index + 1 }
                  TableCell { transaction.fm_created_at }
                  TableCell { transaction.owner_name }
                  TableCell { transaction.fm_amount }
                  TableCell { transaction.fm_activity_key }
                end
              end
            end
          end
        end
      end
    end
  end
end
