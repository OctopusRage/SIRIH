class User < ApplicationRecord
    validates :username, presence: true
    validates :name, presence: true
    has_secure_password
end
