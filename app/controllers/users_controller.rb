class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if session[:user_id].to_i==params[:id].to_i
      puts "Param[:id] is #{params[:id]}"
      puts "session[:user_id is #{session[:user_id]}"
      @user = User.find(session[:user_id])
    else
      redirect_to '/login'
    end
  end

  # GET /users/new
  def new

  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    tmpAdmin = @user.admin

    #Force the first user created to be an admin
    # if User.all.count<1
    #   @user.admin = true
    # else
    #   @user.admin = false
    # end

    # if tmpAdmin=="Yes"
    #   @user.admin = true
    # else
    #   @user.admin = false
    # end
    @user.admin = (User.all.count<1 || tmpAdmin.admin=="Yes")
    respond_to do |format|
      if @user.save
        session[:user_id]=@user.id
        session[:admin]=@user.admin
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        for i in 0..18
           puts "user save fail"
        end
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :age, :password, :phone, :admin)
    end
end