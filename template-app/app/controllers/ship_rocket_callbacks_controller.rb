class ShipRocketCallbacksController < ApplicationController
  def create
    shiprocket_raw = BxBlockOrderManagement::ShipRocketRaw.create(payload: params)
    render json: {message: 'success'}, status: 200
  end
end
