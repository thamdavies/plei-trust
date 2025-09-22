# frozen_string_literal: true

Dir[Rails.root.join("lib/ruby_extensions/*/*.rb")].each { |file| require file }

String.include(RubyExtensions::String::Transform)
