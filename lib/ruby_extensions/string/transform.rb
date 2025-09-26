# frozen_string_literal: true

module RubyExtensions
  module String
    module Transform
      def remove_dots
        to_s.gsub(".", "")
      end

      def remove_dots!
        to_s.!(".", "")
      end

      def remove_dots_and_spaces
        remove_dots.remove_spaces
      end

      def remove_spaces
        to_s.strip.gsub(/\s+/, "")
      end
    end
  end
end
