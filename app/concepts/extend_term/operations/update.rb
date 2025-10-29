module ExtendTerm::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::ContractExtension, :new)
      step Contract::Build(constant: ::ExtendTerm::Contracts::Update)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)

        form = ctx["contract.default"]
        form.number_of_days = model.number_of_days.to_i
        form.note = model.note
        form.contract_id = model.contract_id

        ctx[:contract] = model.contract

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :notify
    }

    def save(ctx, model:, params:, **)
      contract_extension = ContractExtension.create!(
        contract_id: model.contract_id,
        from: Date.current,
        to: Date.current,
        number_of_days: model.number_of_days.to_i,
        note: model.note,
        content: "Gia hạn"
      )

      start_date = regenerate_interest_payments(contract: ctx[:contract])

      contract_extension.from = start_date
      contract_extension.to = start_date + (model.number_of_days.to_i - 1).days
      contract_extension.save!

      true
    end

    # Gia hạn thêm như sau:
    # Nếu kỳ lãi cuối cùng đã được thành toán hoặc số ngày của chu kỳ lãi cuối cùng là 30 ngày thì tạo kỳ lãi mới bắt đầu từ ngày kế tiếp của kỳ lãi cuối cùng
    # Ngược lại, không cần tạo kỳ lãi mới vì kỳ lãi cuối cùng vẫn chưa được thanh toán và có thể được điều chỉnh lại khi thanh toán
    # Ví dụ:
    # - Kỳ lãi cuối cùng từ 01/01/2024 đến 30/01/2024 (30 ngày) đã được thanh toán, thì tạo kỳ lãi mới từ 31/01/2024
    # - Gia hạn thêm 30 ngày, Kỳ lãi cuối cùng từ 01/01/2024 đến 25/01/2024 (25 ngày) chưa được thanh toán, thì phải điền thêm 5 ngày vào kỳ lãi này, còn 25 ngày còn lại sẽ tạo kỳ lãi mới từ 31/01/2024
    def regenerate_interest_payments(contract:)
      last_interest_payment = contract.interest_payments.last
      from_date = last_interest_payment.from

      if last_interest_payment.paid? || last_interest_payment.number_of_days == 30
        start_date = last_interest_payment.to + 1.day
        from_date = start_date
      else
        last_interest_payment.destroy!
        start_date = last_interest_payment.to
        from_date = start_date + 1.day
      end

      ::Contract::Services::ContractInterestPaymentGenerator.call(contract:, start_date:)

      from_date
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Gia hạn thành công!"

      true
    end
  end
end
