class Views::Dashboard::Index < Views::Base
  def page_title = I18n.t("sidebar.dashboard")

  def view_template
  end

  def subtitle = I18n.t("sidebar.dashboard")
end
