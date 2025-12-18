class UsersController < ApplicationController
  include Authenticable
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    users = UserService.all
    render json: users.map { |user| user_response(user) }, status: :ok
  end

  def show
    if @user
      render json: user_response(@user), status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def update
    return render json: { error: "User not found" }, status: :not_found unless @user

    result = UserService.update(@user, user_update_params)

    if result[:success]
      render json: {
        message: "User updated successfully",
        user: user_response(result[:user])
      }, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "User not found" }, status: :not_found unless @user

    result = UserService.destroy(@user)
    render json: { message: result[:message] }, status: :ok
  end

  private

  def set_user
    @user = UserService.find(params[:id])
  end

  def user_update_params
    params.permit(:name, :email, :password)
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
