class UsersController < ApplicationController
  def new
    @user = User.new
    @post = Post.new
    @circles = FriendCircle.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to new_user_url
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @posts = []
    current_user.joined_circles.each do |circle|
      circle.posts.each do |post|
        @posts << post
      end
    end
    @posts = @posts.uniq
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
