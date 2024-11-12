class User::Account < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :notifications, through: :subscriptions
  has_many :authorizations, class_name: "User::Authorization", foreign_key: "account_id"
  has_many :roles, through: :authorizations, class_name: "User::Role", foreign_key: "role_id"

  scope :chronological, -> { order(created_at: :asc) }
  scope :reverse_chronological, -> { order(created_at: :desc) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :company_code, format: {
    with: /\A(\d{6}-\d{4}|\d{8})\z/,
    message: :invalid_company_code,
  }

  def role?(role)
    roles.exists?(name: role)
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
