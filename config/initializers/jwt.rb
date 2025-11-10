JWT_SECRET = ENV.fetch('JWT_SECRET_KEY') { Rails.application.credentials.secret_key_base }
JWT_EXPIRATION = 24.hours.to_i # Tiempo de expiración