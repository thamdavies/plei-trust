class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end

  def fm_created_date
    created_at.to_date.to_fs(:date_vn)
  end

  def fm_created_time
    created_at.to_fs(:date_time_vn)
  end
end
