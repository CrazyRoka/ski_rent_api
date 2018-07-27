class ItemsController < ApplicationController
  before_action :authenticate_user
  has_scope :name
  has_scope :of_category, type: :array
  has_scope :by_options, type: :array
  # has_scope :available_in, using: %i[from_date end_date], type: :hash do |controller, scope, value|
  #   scope.available_in(value[:from_date].to_i, value[:to_date].to_i)
  # end

  # GET /api/item(:id)
  def show
    item = authorize Item.find(params[:id])
    render json: item.extend(ItemRepresenter)
  end

  # GET /api/items
  def index
    items = filter(current_user.items)
    render json: User.new(items: items).extend(UserItemsRepresenter)
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
    params.require(:item).permit(:owner_id, :name, :daily_price_cents, :category, :options,
                                 :lower_price, :upper_price, :days_number, :date)
  end

  def filter(items)
    items = items.of_category(item_params[:category]) if item_params[:category]
    items = items.with_options(item_params[:options]) if item_params[:options]
    items = items.with_name(item_params[:name]) if item_params[:name]
    items = items.with_cost(days_number: item_params[:category],
                            lower_price: item_params[:lower_price],
                            upper_price: item_params[:upper_price]
            ) if item_params[:category] && item_params[:lower_price] && item_params[:upper_price]
    items = items.available_in(item_params[:date]) if item_params[:date]
    items
  end

end