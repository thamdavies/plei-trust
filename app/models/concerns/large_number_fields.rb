module LargeNumberFields
  extend ActiveSupport::Concern

  class_methods do
    # Define large number field với auto conversion
    def large_number_field(field_name, options = {})
      storage_unit = options[:storage_unit] || :thousands  # :thousands, :millions
      divisor = case storage_unit
      when :thousands then 1_000
      when :millions then 1_000_000
      else 1
      end

      # Getter - convert from storage unit (divided) to display unit (original)
      define_method "#{field_name}_display" do
        value = self[field_name]
        return nil unless value

        # Nhân lại để hiển thị số gốc
        (value * divisor).to_i
      end

      # Override original setter để auto-convert
      define_method "#{field_name}=" do |new_value|
        return unless new_value.present?

        if new_value.is_a?(String)
          # Nếu là string từ form, clean và chia
          clean_value = new_value.remove_dots.to_d
          super(clean_value / divisor)
        else
          # Nếu là số từ code, chia luôn
          super(new_value.to_d / divisor)
        end
      end

      # Validation helper - check với giá trị gốc (chưa chia)
      define_method "#{field_name}_within_limit?" do |max_value|
        value = self[field_name]
        return true unless value

        # Nhân lại để so sánh với max_value gốc
        (value * divisor) <= max_value
      end

      # Format for display with thousand separators
      define_method "#{field_name}_formatted" do
        value = send("#{field_name}_display")
        return "" unless value

        ActionController::Base.helpers.number_with_delimiter(
          value,
          delimiter: ".",
          separator: ",",
          precision: 0,
          strip_insignificant_zeros: true
        )
      end

      define_method "#{field_name}_currency" do
        value = send("#{field_name}_formatted")
        return "" unless value

        "#{value} VNĐ"
      end

      # Helper để lấy raw value đã chia (như lưu trong DB)
      define_method "#{field_name}_raw" do
        self[field_name]
      end

      # Helper để set raw value (đã chia sẵn)
      define_method "#{field_name}_raw=" do |value|
        self[field_name] = value
      end
    end
  end
end
