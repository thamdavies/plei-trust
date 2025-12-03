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
            if @transactions.empty?
              TableRow do
                TableCell(colspan: 4, class: "text-center text-muted-foreground") { "Chưa có giao dịch nào" }
              end
            else
              @transactions.each do |transaction|
                TableRow do
                  TableCell { 1 }
                  TableCell { transaction.transaction_date.strftime("%d/%m/%Y") }
                  TableCell { transaction.transaction_type.name }
                  TableCell { number_to_currency(transaction.amount, unit: "VNĐ", precision: 0) }
                  TableCell { transaction.created_by&.full_name }
                end
              end
            end
          end
        end
      end
    end
  end
end
