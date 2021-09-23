class User < ApplicationRecord
  has_many :portfolios, dependent: :destroy
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  validates :full_name, presence: true

  # override methods for user approved col
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  private

  def send_welcome_email
    WelcomeMailer.welome_account_email(email).deliver_now if approved == false
    WelcomeMailer.welcome_account_email_admin(email).deliver_now if approved == true
  end
end
