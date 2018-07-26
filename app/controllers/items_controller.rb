class ItemsController < ApplicationController
  before_action :authenticate_user

  # GET /api/item(:id)
  def show
    item = authorize Item.find(params[:id])
    render json: item.extend(ItemRepresenter)
  end

  # GET /api/items
  def index
    render json: current_user.extend(UserItemsRepresenter)
  end

  # POST /api/items
  def create
    item = Item.create(item_params)
    item.owner = current_user
    if item.save
      render json: item.extend(ItemRepresenter), status: :created
    else
      render json: { errors: item.errors }, status: :conflict
    end
  end

  # PATCH /api/items/:id
  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item.extend(ItemRepresenter)
    else
      render json: { errors: item.errors }, status: :unprocessible_entity
    end
  end

  # DELETE /api/items/:id
  def destroy
    item = authorize Item.find(params[:id])
    item.destroy
    render json: item.extend(ItemRepresenter)
  end

  private

  def item_params
    params.require(:item).permit(:owner_id, :name, :daily_price_cents)
  end

end