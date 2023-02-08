class User < ApplicationRecord
    before_save { self.email = email.downcase }

    validates :name, presence: true,
                        length: { minimum:3, maximum: 25 }
    VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true,
                        uniqueness: { case_sensitive: false },
                        length: { maximum: 105 },
                        format: {with: VALID_EMIAL_REGEX }

    validates :address, presence: true

    NUMBER_REGEX = /\d[0-9]\)*\z/


    validates :phone_number, presence: true,
                        length: { minimum:10 },
                        format: {with: NUMBER_REGEX }

    
    has_secure_password
                        


end