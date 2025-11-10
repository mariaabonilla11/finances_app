module JwtServices
  #Manejo de tokens revocados
  class BlacklistService
    # Agrega un token a la lista negra
    def self.add(token)
      decoded = JwtServices::TokenManagerService.decode(token)
      return false unless decoded

      # Guarda el token en la BD con su expiración
      BlacklistedToken.create!(
        token: token,
        expires_at: Time.at(decoded[:exp])
      )
        
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Blacklist Error: #{e.message}")
      false
    end

    def self.blacklisted?(token)
      BlacklistedToken.exists?(token: token)
    end

    # Limpia tokens que ya expiraron (mantenimiento)
    def self.cleanup_expired
      BlacklistedToken.where('expires_at < ?', Time.current).delete_all
    end
  end
end
