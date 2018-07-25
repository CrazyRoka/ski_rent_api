class ItemController < ApplicationController
  before_action :authenticate_user
  include Roar::Rails::ControllerAdditions
  respond_to :json

  # GET /api/item(:id)
  def item
    item = Item.find_by(id: item_params[:id])
    if item && item.owner == current_user
      respond_with item
    else
      render json: '', status: :unauthorized
    end
  end

  # GET /api/items
  def items
    respond_with current_user, :represent_with => UserItemsRepresenter
  end

  # POST /api/items/create
  def create
    item = Item.create(item_params)
    item.owner = current_user
    if item.save
      respond_with item, status: :created
    else
      p item.errors
      render json: '', status: :conflict
    end
  end

  # POST /api/item/update
  def update
    item = Item.find_by(id: item_params[:id])
    if item && item.update(item_params)
      respond_with item, status: :ok
    else
      render json: '', status: :not_found
    end
  end

  # POST /api/item/destroy
  def destroy
    item = Item.find_by(id: item_params[:id])
    if item && item.owner == current_user
      item.destroy()
      respond_with item, status: :ok
    else
      render json: '', status: :unauthorized
    end
  end

  private

  def item_params
    params.require(:item).permit(:id, :owner_id, :name, :daily_price_cents)
  end

end