class AuthenticationService
  def self.register(params)
    user = User.new(params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      { success: true, token: token, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  def self.login(email, password)
    user = User.find_by(email: email)

    if user&.authenticate(password)
      token = JsonWebToken.encode(user_id: user.id)
      { success: true, token: token, user: user }
    else
      { success: false, error: "Invalid email or password" }
    end
  end
end
