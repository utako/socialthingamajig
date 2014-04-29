class PostsController < ApplicationController
  def new
    @post = Post.new
    @circles = current_user.friend_circles
    3.times { @post.links << Link.new }
  end
  #/users/:user_id/posts/:post_id/links(.:format)
  #/users/:user_id/posts/:post_id/links/new(.:format)
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.links.new(link_params)
    shares_params[:friend_circle_ids].each do |circle_id|
      @post.shares.new(friend_circle_id: circle_id)
    end
    if @post.save
      redirect_to user_post_url(current_user, @post)
    else
      flash.now[:errors] = @post.errors.full_messages
      (3 - @post.links.length).times { @post.links << Link.new }
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

    def post_params
      params.require(:post).permit(:body)
    end

    def link_params
      params.permit(links: [:title, :url])
        .require(:links)
        .values
        .reject { |data| data.values.all?(&:blank?) }
    end

    def shares_params
      params.require(:post_share)
        .permit(friend_circle_ids: [])
    end
end