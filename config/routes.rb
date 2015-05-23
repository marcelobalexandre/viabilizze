Rails.application.routes.draw do
  scope "/:locale", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users

    resources :users do
      resources :projects do
        resources :units
        resources :multiple_units, only: [:new, :create]
        resources :sensitivity_analyses do
          get 'selling_price', on: :collection
        end
      end
    end

    root 'home#index'
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }
  get '', to: redirect("/#{I18n.default_locale}")
end