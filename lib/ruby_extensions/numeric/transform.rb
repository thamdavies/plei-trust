# frozen_string_literal: true

module RubyExtensions
  module Numeric
    module Transform
      def to_currency(unit: "VNĐ")
        ActionController::Base.helpers.number_with_delimiter(
          self.to_i,
          delimiter: ".",
          separator: ",",
          precision: 0,
          strip_insignificant_zeros: true
        ) + " #{unit}"
      rescue StandardError => e
        Rails.logger.error("BigDecimal#to_currency error: #{e.message}")
        self
      end
    end
  end
end
