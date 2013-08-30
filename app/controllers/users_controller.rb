class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [ :new, :create ]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :followers, :followings, :follow, :unfollow]

  # GET /users
  # GET /users.json
  def index
    if params[:search].blank?
      @users = User.paginate(page: params[:page])
    else
      @users = User.search do
        fulltext params[:search]
        paginate(page: params[:page])
        order_by :created_at, :desc
      end.results
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @posts = @user.posts.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(create_params)
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to @user
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(update_params)
      flash[:success] = "Settings updated"
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def followers
    @users = @user.followers.paginate(page: params[:page])
    @title = "Followers"
    render "followings"
  end

  def followings
    @users = @user.followed_users.paginate(page: params[:page])
    @title = "Followed Users"
    render "followings"
  end

  def follow
    if request.xhr?
      render status: current_user.follow(@user).nil? ? 400 : 200, nothing: true
    else
      if current_user.follow(@user)
        flash[:success] = "You are following #{@user.name}"
      else
        flash[:error] = "Something went wrong.  You cannot follow #{@user.name}"
      end
      redirect_to @user
    end
  end

  def unfollow
    if request.xhr?
      render status: current_user.unfollow(@user) ? 200 : 400, nothing: true
    else
      if current_user.unfollow(@user)
        flash[:success] = "You are no longer following #{@user.name}"
      else
        flash[:error] = "Something went wrong.  You cannot unfollow #{@user.name}"
      end
      redirect_to @user
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def update_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
