# frozen_string_literal: true

module Staff::Contracts
  class Update < ApplicationContract
    property :id
    property :branch_id
    property :full_name
    property :email
    property :phone
    property :status

    property :password
    property :password_confirmation, virtual: true

    validation contract: DryContract do
      option :form

      params do
        required(:id).filled
        required(:full_name).filled
        required(:email).filled
        required(:branch_id).filled
        required(:status).filled

        optional(:phone).value(max_size?: 50)
        optional(:password)
        optional(:password_confirmation)
      end

      rule(:email) do
        if value.present? && !URI::MailTo::EMAIL_REGEXP.match?(value)
          key.failure(:invalid_format)
        end

        if value.present? && User.where(email: value).where.not(id: form.id).exists?
          key.failure(:taken)
        end
      end

      rule(:phone) do
        if value.present? && !Phonelib.valid?(value)
          key.failure(:invalid_phone_number)
        end
      end

      rule(:password_confirmation) do
        if value != form.password
          key.failure(:password_mismatch)
        end
      end
    end
  end
end
