class AdminsController < ApplicationController
  def trader_settings
    @traders = User.where(approved: true)
  end

  def approvals
    @traders = User.where(approved: false)
  end

  # patch method
  def approve_account
    @trader = User.find(params[:id])
    @trader.approved = params[:approve]
    @trader.save
    if @trader.save
      ApproveMailer.approve_account_email(@trader.email).deliver_now
      redirect_to admins_trader_settings_path fallback_location: admins_add_user_path, success: 'Successfully approved a trader'
    else
      redirect_to admins_trader_settings_path fallback_location: admins_add_user_path, danger: 'Approval failed'
    end
  end

  def add_user
    @trader = User.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create_user
    @trader = User.new(params.require(:user).permit(:email, :password, :full_name, :username))
    @trader.approved = true
    @trader.save
    if @trader.save
      WelcomeMailer.welome_account_email(@trader.email).deliver_now
      redirect_back fallback_location: admins_add_user_path, success: 'Successfully created a trader'
    else
      redirect_back fallback_location: admins_add_user_path, danger: 'Kindly double check all information before submitting'
    end
  end

  def show_user
    @trader = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit_user
    @trader = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def modify_user
    @trader = User.find(params[:id])
    @trader.update(params.require(:user).permit(:email, :full_name, :username))
    if @trader.update(params.require(:user).permit(:email, :full_name, :username))
      redirect_back fallback_location: admins_add_user_path, success: 'Successfully updated a trader'
    else
      redirect_back fallback_location: admins_add_user_path, danger: 'Kindly double check all information before submitting'
    end
  end

  # def transactions; end #uncomment once transaction models has been created
end
