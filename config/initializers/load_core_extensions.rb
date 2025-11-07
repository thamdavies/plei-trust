# frozen_string_literal: true

Dir[Rails.root.join("lib/ruby_extensions/*/*.rb")].each { |file| require file }

String.include(RubyExtensions::String::Transform)
BigDecimal.include(RubyExtensions::Numeric::Transform)
Float.include(RubyExtensions::Numeric::Transform)
Integer.include(RubyExtensions::Numeric::Transform)
# NilClass.include(RubyExtensions::NilClass::Transform)
