class PotatoPricesController < ApplicationController
  before_action :get_prices

  def prices
    render json: @prices.map {|p| {"time": p["time"], "value": p["value"]}}
  end

  def best_gain
    prices = @prices.pluck(:value)
    # Recherche d'un minimum local et d'un maximum local
    if params[:n_operations]
      result = n_operations(prices)
    # Calculer la différence entre le prix d'achat le plus bas et le prix de vente le plus haut
    else
      result = one_operation(prices)
    end

    render json: result
  end

  private

  def get_prices
    date = params[:date]
    start_of_day = Date.parse(date).beginning_of_day
    end_of_day = Date.parse(date).end_of_day
    @prices = PotatoPrice.day(start_of_day, end_of_day)
  end

  def one_operation(prices)
    max_gain = 0
    capacitiy = 100
    buy_price = prices.first
  
    prices.each do |price|
      # Comparer les prix pour trouver le prix d'achat le plus bas
      buy_price = price if price < buy_price
      # Calculer le gain potentiel entre le prix d'achat le plus bas et le prix actuel
      gain = price.to_f - buy_price.to_f
      # Comparer les gains potentiels pour trouver le meilleur gain possible
      max_gain = gain if gain > max_gain
    end
 
    return { best_gain: "#{(max_gain * capacitiy).round(2)}€" }
  end

  def n_operations(prices)
    total_max_gain = []
    max_gain = 0
    i = 0

    while i < prices.length - 1
      # Recherche d'un minimum/maximum local pour la première valeur
      if i == 0
        if prices[i] <= prices[i+1]
          buy_price = prices[i]
          sell_price = prices[i+1]
          total_max_gain << sell_price - buy_price
        end
      # Recherche d'un minimum/maximum local sur les autres valeurs
      else
        if (prices[i] <= prices[i-1]) && (prices[i] <= prices[i+1])
          buy_price = prices[i]
          sell_price = prices[i+1]
          total_max_gain << sell_price - buy_price
        end
      end
    
      i += 1
    end
    # Calculer le gain pour chaque transaction en imputant la capacité d'achat
    # Partons du principe que chaque transaction est faite sur le même nombre de tonnes de pommes de terre
    nb_trans = total_max_gain.count
    capacitiy = 100.to_f / nb_trans
    max_gain = total_max_gain.map{|gain| gain * capacitiy.round(2)}

    return { best_gain: "#{max_gain.sum().round(2)}€" }
  end
end
