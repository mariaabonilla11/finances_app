module JwtServices
  class RefreshToken
    attr_reader :user, :token

    def initialize(user)
      @user = user
    end

    def generate
      @token = SecureRandom.hex(32)
      user.refresh_tokens.create!(
        token: @token,
        expires_at: 30.days.from_now
      )
      @token
    end

    def self.find_user(token)
      refresh_token = ::RefreshToken.active.find_by(token: token)
      refresh_token&.user
    end

    def self.revoke(token)
      refresh_token = ::RefreshToken.find_by(token: token)
      refresh_token&.destroy
      return refresh_token
    end

    def self.revoke_all(user)
      user.refresh_tokens.destroy_all
    end

    def self.cleanup_expired
      ::RefreshToken.expired.delete_all
    end

    def self.expired_refresh_token(user)
      @token = SecureRandom.hex(32)
      user.refresh_tokens.create!(
        token: @token,
        expires_at: -30.days.from_now
      )
      @token
    end

    def self.expired?(token)
      return true if token.blank?
      
      refresh_token = ::RefreshToken.find_by(token: token)
      return true unless refresh_token
      
      refresh_token.expires_at <= Time.current
    end
  end
end