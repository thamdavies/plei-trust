module Customer::Reader
  extend ActiveSupport::Concern

  def old_debt_amount
    Contract.where(customer_id: id).map { |c| c.old_debt_amount }.sum.to_f
  end

  def blobs
    files.map do |file|
      {
        id: file.id,
        filename: file.filename,
        byte_size: file.byte_size,
        signed_id: file.signed_id,
        url: Rails.application.routes.url_helpers.rails_blob_url(file, host: Settings.host),
        remove_url: "/contracts/files/:ID"
      }
    end
  end
end
