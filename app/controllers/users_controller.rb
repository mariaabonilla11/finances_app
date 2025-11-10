class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:login]

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: "User created!" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
