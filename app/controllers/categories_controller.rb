class CategoriesController < ApplicationController
  #before_action :authenticate_user

  def index
    categories = Category.all.map { |c| CategoryRepresenter.new(c) }
    render json: { categories: categories }
  end
end
