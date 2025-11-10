# app/controllers/concerns/authenticable.rb
module Authenticable
  extend ActiveSupport::Concern

  private

  def authorize_request
    token = extract_token
    
    unless token
      render json: { success: false, message: 'Token no proporcionado' }, status: :unauthorized
      return
    end

    if JwtServices::BlacklistService.blacklisted?(token)
      render json: { success: false, message: 'Token revocado' }, status: :unauthorized
      return
    end

    begin
      decoded = JwtServices::TokenManagerService.decode(token)
      if decoded.nil?
        render json: { success: false, message: 'Token inválido o expirado' }, status: :unauthorized
        return
      end
      @current_user = User.find(decoded[:user_id])
      if @current_user.inactive?
        render json: { success: false, message: 'Usuario inactivo' }, status: :unauthorized
        return
      end
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, message: 'Usuario no encontrado' }, status: :unauthorized
    end
  end

  def extract_token
    header = request.headers['Authorization']
    header.split(' ').last if header
  end

  def current_user
    @current_user
  end
end