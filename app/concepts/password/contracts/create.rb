class Password::Contracts::Create < ApplicationContract
  property :email, virtual: true

  validation contract: DryContract do
    params do
      required(:email).filled(:string)
    end

    rule(:email) do
      key.failure(I18n.t("errors.messages.invalid")) unless value =~ URI::MailTo::EMAIL_REGEXP
    end
  end
end
