class UsersController < ApplicationController
    skip_before_action :logged_in?, only: [:create, :login]

    def index
        users = User.all
        
        render json: users
    end

    def create
        user = User.new(user_params)
        if user.valid?
            user.save
            render json: {user: UserSerializer.new(user), token: encode_token({user_id: user.id})}
        else
            render json: {error: "Failed to create the user"}
        end
    end


    def login
       
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
            render json: {user: UserSerializer.new(user), token: encode_token({user_id: user.id})}
           
        else
            render json: {error: "Invalid username or Password"}
        end
    end

    private

    def user_params
        params.permit(:email, :password)
    end

end
