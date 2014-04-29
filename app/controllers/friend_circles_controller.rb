class FriendCirclesController < ApplicationController
  def new
    @circle = FriendCircle.new
    @users = User.all
  end

  def create
    @circle = FriendCircle.new(circle_params)
    @circle.user_id = current_user.id
    membership_params[:user_ids].each do |user_id|
      next if user_id.blank?
      @circle.memberships.new(user_id: user_id)
    end
    @circle.memberships.new(user_id: current_user.id)
    if @circle.save
      redirect_to user_friend_circle_url(current_user, @circle)
    else
      flash.now[:errors] = @circle.errors.full_messages
      render :new
    end
  end

  def edit
    @users = User.all
    @circle = FriendCircle.find(params[:id])
  end

  def update
    @circle = FriendCircle.find(params[:id])
    @circle.update_attributes(circle_params)
    memberships = @circle.memberships
    @current_member_ids = @circle.members.map(&:id).uniq

    membership_params[:user_ids].each do |user_id|
      next if @current_member_ids.include?(user_id) || user_id.blank?
      membership = FriendCircleMembership.where(
        user_id: user_id,
        friend_circle_id: @circle.id
      )
      @circle.memberships.new(user_id: user_id) if membership.empty?
    end

    memberships.each do |membership|
      unless membership_params[:user_ids].include?(membership.user_id.to_s)
        membership.destroy
      end
    end

    if @circle.save
      redirect_to user_friend_circle_url(current_user, @circle)
    else
      flash.now[:errors] = @circle.errors.full_messages
      render :edit
    end
  end

  def index
    @circles = FriendCircle.where(user_id: current_user.id)
  end

  def destroy
  end

  def show
    @circle = FriendCircle.find(params[:id])
  end

  private

    def circle_params
      params.require(:circle).permit(:name)
    end

    def membership_params
      params.require(:membership)
        .permit(user_ids: [])
    end
end
