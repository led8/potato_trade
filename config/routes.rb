Rails.application.routes.draw do
  get "home", to: "pages#home"
  get "generate", to: "pages#generate", as: :generate
  get "potato-prices/:date", to: "potato_prices#prices", as: :prices
  get "potato-prices/:date/best-gain", to: "potato_prices#best_gain", as: :best_gain
end
