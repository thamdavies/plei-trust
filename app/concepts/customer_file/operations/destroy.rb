module CustomerFile::Operations
  class Destroy < ApplicationOperation
    step Wrap(AppTransaction) {
      step :save
    }

    def save(ctx, params:, **)
      blob = ActiveStorage::Blob.find_signed(params[:id])
      if blob
        if blob.attachments.any?
          blob.attachments.each(&:purge)
        else
          blob.purge
        end
      end

      true
    end
  end
end
