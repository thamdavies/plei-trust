module ContractFile::Operations
  class Create < ApplicationOperation
    class FileForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :files, :contract_id

      def contract
        @contract ||= Contract.find(contract_id)
      end
    end

    class Present < ApplicationOperation
      step Model(FileForm, :new)
      step Contract::Build(constant: ContractFile::Contracts::Create)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)
        ctx[:contract] = model.contract

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()

    step Wrap(AppTransaction) {
      step :save
    }

    def save(ctx, model:, **)
      contract = model.contract
      contract.files.attach(model.files)

      true
    end
  end
end
