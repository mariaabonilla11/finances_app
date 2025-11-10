module JwtServices
  #  Validación y autenticación de tokens JWT
  class Authenticator
    attr_reader :token, :decoded_token

    def initialize(token)
      @token = token
      @decoded_token = JwtServices::TokenManagerService.decode(token)
    end

    def valid?
      return false if decoded_token.nil?
      return false if JwtServices::Blacklist.blacklisted?(token)
      return false if expired?
      
      true
    end

    def user
      return nil unless valid?
      
      @user ||= User.find_by(id: decoded_token[:user_id])
    end

    def expired?
      return true unless decoded_token
      
      Time.at(decoded_token[:exp]) < Time.current
    rescue
      true
    end

    def self.authenticate(token)
      authenticator = new(token)
      authenticator.valid? ? authenticator.user : nil
    end
  end
end