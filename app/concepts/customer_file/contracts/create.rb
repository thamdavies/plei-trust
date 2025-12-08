module CustomerFile::Contracts
  class Create < ApplicationContract
    property :files
    property :customer_id

    validation contract: DryContract do
      option :form

      params do
        required(:files).filled
        required(:customer_id).filled
      end

      rule(:files) do
        customer = ::Customer.find(form.customer_id)
        customer_files_count = customer.files.count
        signed_ids = customer.blobs.map { |b| b[:signed_id] }
        new_files_count = value.compact_blank.reject { |file| signed_ids.include?(file) }.size
        total_files_count = customer_files_count + new_files_count
        max_files = Settings.max_number_of_file_uploads || 4

        if total_files_count > max_files
          key.failure("Chỉ được tải lên tối đa #{max_files} tệp. Hiện tại đã có #{customer_files_count} tệp, bạn chỉ có thể tải thêm #{max_files - customer_files_count} tệp nữa.")
        end
      end
    end
  end
end
