# frozen_string_literal: true

module RubyExtensions
  module String
    module Transform
      def remove_dot
        gsub(".", "")
      end

      def remove_dot!
        gsub!(".", "")
      end
    end
  end
end
