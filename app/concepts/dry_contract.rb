# frozen_string_literal: true

class DryContract < Dry::Validation::Contract
  config.messages.backend = :i18n
  config.messages.default_locale = I18n.default_locale
  config.messages.load_paths << Rails.root.join("config/locales/errors.#{I18n.locale}.yml")
end
