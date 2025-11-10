 def create
    account = Account.new(user_params)
    if account.save
      render json: { message: "Account created!" }, status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end