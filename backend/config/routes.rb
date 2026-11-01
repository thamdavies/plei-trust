Rails.application.routes.draw do
  if Rails.env.development?
    mount Rswag::Api::Engine => "/api-docs"
    mount Rswag::Ui::Engine => "/api-docs"
  end

  namespace :api do
    namespace :v1 do
      resource :health, only: :show, controller: :health
      resource :session, only: %i[create destroy], controller: :sessions
      resource :me, only: :show, controller: :me
    end
  end
end
