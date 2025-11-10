# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  include ParameterValidator
  skip_before_action :authorize_request, only: [:login, :register, :refresh]

  def login
    # Validar parámetros requeridos
    result_validate = validate_required_params([:email, :password])
    if !result_validate[:valid]
      return render json: { success: false, message: 'Faltan parámetros requeridos', errors: result_validate[:result] }, status: :bad_request
    end

    @user = find_user(params[:email])
    
    if !@user 
      return render json: { success: false, message: 'Usuario no encontrado o inactivo' }, status: :unauthorized
    end

    if @user&.authenticate(params[:password])
      token = JwtServices::TokenManagerService.encode_for_user(@user, expiration_data[:timestamp])
      refresh_token = JwtServices::RefreshToken.new(@user).generate

      render json: {
        success: true,
        message: "Inicio de sesión exitoso",
        token: token,
        refresh_token: refresh_token,
        exp: Time.at(expiration_data[:timestamp]).utc.iso8601,   
        user: @user.id
      }, status: :ok
    else
      render json: { success: false, message: 'Credenciales inválidas' }, status: :unauthorized
    end
  end

  def register
    begin 
      result_validate = validate_required_params([:first_name, :last_name, :email, :password])
      if !result_validate[:valid]
        return render json: { success: false, message: 'Faltan parámetros requeridos', errors: result_validate[:result] }, status: :bad_request
      end

      user = User.new(
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: params[:password],
        state: :active
      )

      if user.save
        render json: { success: true, message: 'Usuario registrado exitosamente', user_id: user.id }, status: :created
      else
        render json: { success: false, message: 'Error al registrar usuario', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false, message: 'Error interno del servidor', error: e.message }, status: :internal_server_error
    end
  end

  def logout 
    access_token = extract_token
    refresh_token = params[:refresh_token]

    unless access_token 
      render json: { success: false, message: 'Token no proporcionado'}, status: :unauthorized
    end

    begin JwtServices::BlacklistService.add(access_token)
      JwtServices::RefreshToken.revoke(refresh_token) if refresh_token.present?
      render json: { success: true, message: 'Sesión cerrada exitosamente' }, status: :ok
    rescue => e
      render json: { success: false, message: 'Error al cerrar sesión', error: e.message }, status: :internal_server_error
    end
  end

  def refresh
    refresh_token = params[:refresh_token]

    unless refresh_token
      render json: { success: false, message: 'Refresh token no proporcionado' }, status: :unauthorized
      return
    end

    user = JwtServices::RefreshToken.find_user(refresh_token)
    unless user
      render json: { success: false, message: 'Refresh token inválido o expirado' }, status: :unauthorized
      return
    end
  
    if user.inactive?
      render json: { success: false, message: 'Refresh token inválido, usuario inactivo' }, status: :unauthorized
      return
    end

    new_access_token = JwtServices::TokenManagerService.encode_for_user(user, expiration_data[:timestamp])
    render json: { 
      success: true, 
      token: new_access_token, 
      exp: Time.at(expiration_data[:timestamp]).utc.iso8601 
    }, status: :ok
  end

  def me
    render json: {
      user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name,
        created_at: current_user.created_at
      }
    }, status: :ok
  end

  # Metodos comunes
  private
  
  def find_user(email)
    User.find_by(email: email, state: :active)
  end

  def extract_token
    header = request.headers['Authorization']
    header.split(' ').last if header&.start_with?('Bearer ')
  end

  def expiration_data
    hours = JWT_EXPIRATION.to_i
    seconds = hours.hours
    timestamp = (Time.current + seconds).to_i

    { hours: hours, seconds: seconds, timestamp: timestamp }
  end
end