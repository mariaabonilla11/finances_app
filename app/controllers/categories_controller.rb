class CategoriesController < ApplicationController
  def create
    category = Category.new(user_params)
    if category.save
      render json: { message: "Category created!" }, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end
end