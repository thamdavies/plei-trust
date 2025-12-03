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
              @transactions.each_with_index do |transaction, index|
                TableRow do
                  TableCell { index + 1 }
                  TableCell { transaction.fm_transaction_date }
                  TableCell { transaction.created_by.full_name }
                  TableCell { transaction.amount_formatted }
                  TableCell { transaction.fm_cash_control_action_type }
                end
              end
            end
          end
        end
      end
    end
  end
end
