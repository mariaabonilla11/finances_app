module RequestHelpers
  def json_response
    response.parsed_body
  end

  def generate_token(user)
    hours = JWT_EXPIRATION.to_i
    seconds = hours.hours
    timestamp = (Time.current + seconds).to_i
    JwtServices::TokenManagerService.encode_for_user(user, timestamp)
  end

  def generate_refresh_token(user)
    JwtServices::RefreshToken.new(user).generate
  end

  def generate_refresh_token_expired(user)
    refresh_token = JwtServices::RefreshToken.expired_refresh_token(user)
    return refresh_token
  end

  def generate_token_expired(user)
    seconds = -3600
    timestamp = (Time.current + seconds).to_i
    JwtServices::TokenManagerService.encode_for_user(user, timestamp)
  end

end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end