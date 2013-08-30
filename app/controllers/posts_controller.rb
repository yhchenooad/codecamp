class PostsController < ApplicationController
	def index
    if params[:search].blank?
  		@posts = Post.from_followed_users(current_user).order("created_at DESC").paginate(page: params[:page])
    else
      @posts = Post.search do
        fulltext params[:search]
        paginate(page: params[:page])
        order_by :created_at, :desc
      end.results
    end
		@post = current_user.posts.build
	end

  def create
  	@post = current_user.posts.build(create_params)
  	if @post.save
  		flash[:success] = "Posted successfully"
  		redirect_to posts_path
  	else
      flash[:error] = @post.errors.full_messages.first
      redirect_to posts_path
  	end
  end

  def destroy
  	@post = current_user.posts.find_by(id: params[:id])
  	if @post && @post.destroy
	  	flash[:success] = "Post deleted"
	  else
	  	flash[:error] = "Cannot delete post"
	  end
  	redirect_to posts_path
  end

  private

  def create_params
  	params.require(:post).permit(:content)
  end
end
