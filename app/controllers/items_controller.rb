class ItemsController < ApplicationController
  #before_action :authenticate_user

  has_scope :with_name
  has_scope :of_category, type: :array
  has_scope :by_options, type: :array
  has_scope :by_cost, using: %i[days_number lower_price upper_price],
                      type: :hash do |_controller, scope, value|
    scope.by_cost(*value.map(&:to_i))
  end
  has_scope :available_in, using: %i[from_date to_date],
                           type: :hash do |_controller, scope, value|
    scope.available_in(Time.parse(value[0]), Time.parse(value[1]))
  end

  # GET /api/item(:id)
  def show
    item = Item.find(params[:id])
    # item = authorize Item.find(params[:id])
    render json: ItemRepresenter.new(item)
  end

  # GET /api/items
  def index
    items = apply_scopes(Item).all
    render json: UserItemsRepresenter.new(User.new(items: items))
  end

  # POST /api/items
  def create
    item = Item.create(item_params)
    item.owner = current_user
    if item.save
      render json: ItemRepresenter.new(item), status: :created
    else
      render json: { errors: item.errors }, status: :conflict
    end
  end

  # PATCH /api/items/:id
  def update
    # item = authorize Item.find(params[:id])
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemRepresenter.new(item)
    else
      render json: { errors: item.errors }, status: :unprocessible_entity
    end
  end

  # DELETE /api/items/:id
  def destroy
    item = Item.find(params[:id])
    # item = authorize Item.find(params[:id])
    item.destroy
    render json: ItemRepresenter.new(item)
  end

  # POST /api/items/import
  def import
    answer = ImportItemsCsv.new
                           .with_step_args(validate: [user: current_user])
                           .call(params[:csv])
    if answer.success?
      head :created
    else
      render json: { error: answer.failure }, status: :not_acceptable
    end
  end

  private

  def item_params
    params.require(:item).permit(:owner_id, :name, :daily_price_cents,
                                 :category_id, option_ids: [])
  end
end
