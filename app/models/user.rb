class User < ApplicationRecord
  has_many :subscriptions
  has_many :notifications, through: :subscriptions
  has_many :results, through: :notifications
  has_many :roles

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true
  validates :company_code, format: {
    with: /\A\d{6}-\d{4}\z/,
    message: :invalid_company_code,
  }

  def admin?
    !roles.admin.empty?
  end
end
