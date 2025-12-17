class UserService
  def self.all
    User.all
  end

  def self.find(id)
    User.find_by(id: id)
  end

  def self.update(user, params)
    if user.update(params)
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  def self.destroy(user)
    user.destroy
    { success: true, message: "User deleted successfully" }
  end
end
