module CustomInterestPayment::Contracts
  class Update < ApplicationContract
    property :from_date # Lãi từ ngày
    property :to_date # Đến ngày
    property :days_count # Số ngày
    property :interest_amount # Tiền lãi
    property :other_amount, default: 0 # Tiền khác
    property :total_interest_amount # Tổng tiền lãi
    property :customer_payment_amount # Tiền khách đưa

    # Virtual properties for calculation
    property :next_interest_date, virtual: true # Ngày đóng lãi tiếp theo
    property :daily_interest_rate, virtual: true # Lãi suất theo ngày
  end
end
