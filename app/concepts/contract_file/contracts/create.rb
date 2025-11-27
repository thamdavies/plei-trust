module ContractFile::Contracts
  class Create < ApplicationContract
    property :files
    property :contract_id

    validation contract: DryContract do
      option :form

      params do
        required(:files).filled
        required(:contract_id).filled
      end

      rule(:files) do
        contract = ::Contract.find(form.contract_id)
        contract_files_count = contract.files.count
        signed_ids = contract.blobs.map { |b| b[:signed_id] }
        new_files_count = value.compact_blank.reject { |file| signed_ids.include?(file) }.size
        total_files_count = contract_files_count + new_files_count

        max_files = Settings.max_number_of_file_uploads || 4

        if total_files_count > max_files
          key.failure("Chỉ được tải lên tối đa #{max_files} tệp. Hiện tại đã có #{contract_files_count} tệp, bạn chỉ có thể tải thêm #{max_files - contract_files_count} tệp nữa.")
        end
      end
    end
  end
end
