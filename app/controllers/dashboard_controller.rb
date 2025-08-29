class DashboardController < ApplicationController
  layout false

  Article = Data.define(:title)

  def index
    article1 = Article.new(
      title: 'AAA'
    )
    render Views::Articles::Index.new(
      articles: [article1]
    )
  end
end