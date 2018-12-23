class User < ApplicationRecord
  validates :name, :mail, :password, presence: true
  validates :mail, format: { with: URI::MailTo::EMAIL_REGEXP }
end
