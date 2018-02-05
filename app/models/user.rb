class User < ApplicationRecord
  devise :database_authenticatable, :token_authenticatable

  has_many :posts

  before_save :ensure_authentication_token
end
