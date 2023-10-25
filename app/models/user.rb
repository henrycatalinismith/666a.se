class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :notifications, through: :subscriptions
  has_many :roles, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, presence: true
  validates :company_code, format: {
    with: /\A(\d{6}-\d{4}|\d{8})\z/,
    message: :invalid_company_code,
  }

  def admin?
    !roles.admin.empty?
  end

  def to_gdpr_json
    {
      name: name,
      email: email,
      language: locale,
      subscriptions: subscriptions.map { |s| s.company_subscription? ? s.company_code : s.workplace_code },
      notifications: notifications.map { |n|
        {
          date: n.created_at.strftime("%Y-%m-%d"),
          document: n.document.document_code,
        }
      },
    }
  end
end
