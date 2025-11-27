module CustomerFile::Operations
  class Create < ApplicationOperation
    class FileForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :files, :customer_id

      def customer
        @customer ||= Customer.find(customer_id)
      end
    end

    class Present < ApplicationOperation
      step Model(FileForm, :new)
      step Contract::Build(constant: CustomerFile::Contracts::Create)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)
        ctx[:customer] = model.customer

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()

    step Wrap(AppTransaction) {
      step :save
    }

    def save(ctx, model:, **)
      customer = model.customer
      customer.files.attach(model.files)

      true
    end
  end
end
