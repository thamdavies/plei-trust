class Views::Articles::Index < Views::Base
  def initialize(articles:)
    @articles = articles
  end

  def page_title = "Articles"

  def view_template
    h1 { "Articles" }
    ul do
      @articles.each do |article|
        li { article.title }
      end
    end
  end
end