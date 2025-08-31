class Views::Dashboard::Index < Views::Base
  def page_title = "Dashboard"

  def view_template
    h1 { "Dashboard" }
  end
end
