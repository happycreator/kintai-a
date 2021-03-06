class UsersController < ApplicationController
   before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
   before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy
   
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Emailを確認してアカウントの有効化をクリックしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを変更しました。"
      redirect_to @user
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  def import_csv
    User.import_csv(params[:file])
    redirect_to users_url, notice: "ユーザーを追加しました"
  end
  
  # def users_csv(file)
  #   # User.rbに記述すべきだが、今回はusersをインポートするだけなのでusers_csvとしている。
  #   # usersを追加するだけなので、コントローラー内のメソッドに処理を記述する。
  #   CSV.foreach(file.path, headers: true) do |row|
  #     @User = User.new
  #     @User.attributes = row.to_hash.slice(*csv_attributes)
  #     @user.save!
  #   end
  # end
  
  def attendance_users
    @users = User.attendancing
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,:role, :employee_number, :card_id,
                                   :base_attendance_time, :start_attendance_time, :end_attendance_time, :password_confirmation)
    end
 # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
       store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      #アドミンユーザーなら編集できる
      if current_user.admin == true || current_user?(@user)
      else 
        redirect_to(root_url) 
      end
    end
    
     # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end