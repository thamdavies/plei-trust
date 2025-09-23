module ApplicationHelper
  include RubyUI
  include Pagy::Frontend

  def active_link_class(path, active: :exact)
    active_link_to_class(path, class_active: "dark:bg-gray-700 bg-gray-100", active:)
  end

  def active_paths_class(paths)
    paths.any? { |path| is_active_link?(path, :inclusive) } ? "" : "hidden"
  end

  def active_paths?(paths)
    paths.any? { |path| is_active_link?(path, :inclusive) }
  end

  def without_filter_form?
    @without_filter_form
  end
end
