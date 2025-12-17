class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def register
    result = AuthenticationService.register(user_params)

    if result[:success]
      render json: {
        message: "User created successfully",
        token: result[:token],
        user: user_response(result[:user])
      }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def login
    result = AuthenticationService.login(params[:email], params[:password])

    if result[:success]
      render json: {
        message: "Login successful",
        token: result[:token],
        user: user_response(result[:user])
      }, status: :ok
    else
      render json: { error: result[:error] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def user_response(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      created_at: user.created_at
    }
  end
end
