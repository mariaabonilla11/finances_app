module JwtServices
  class TokenManagerService
    SECRET_KEY = Rails.application.credentials.secret_key_base
    ALGORITHM = 'HS256'.freeze

      # Genera token desde un objeto User
      def self.encode_for_user(user, expiration)
        payload = build_user_payload(user)
        encode(payload, expiration)
      end

      # Encode genérico (para otros casos)
      def self.encode(payload, expiration)
        payload[:exp] = expiration
        payload[:iat] = Time.current.to_i
        ::JWT.encode(payload, SECRET_KEY, ALGORITHM)
      end

      def self.decode(token)
        body = ::JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)[0]
        HashWithIndifferentAccess.new(body)
      rescue ::JWT::DecodeError, ::JWT::ExpiredSignature => e
        Rails.logger.error("JWT Decode Error: #{e.message}")
        nil
      end

      def self.expired?(token)
        decoded = decode(token)
        return true unless decoded
        
        Time.at(decoded[:exp]) < Time.current
      rescue
        true
      end

      private

      # Construye el payload con info segura del usuario
      def self.build_user_payload(user)
        {
          user_id: user.id,
          email: user.email,
          jti: SecureRandom.uuid  # Identificador único del token
        }
      end
  end
end