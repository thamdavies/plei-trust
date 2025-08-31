class Login::Contracts::Create < ApplicationContract
  property :email, virtual: true
  property :password, virtual: true

  validation contract: DryContract do
    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email) do
      key.failure("không hợp lệ") unless value =~ URI::MailTo::EMAIL_REGEXP
    end

    rule(:password) do
      key.failure("phải lớn hơn 6 ký tự") if value.length < 6
    end
  end
end
