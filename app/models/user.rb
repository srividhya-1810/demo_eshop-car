class User < ApplicationRecord
    has_many :cars, dependent: :delete_all
    before_save { self.email = email.downcase }


    validates :name, presence: true,
                        length: { minimum:3, maximum: 25 }
    VALID_EMIAL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true,
                        uniqueness: { case_sensitive: false },
                        length: { maximum: 105 },
                        format: {with: VALID_EMIAL_REGEX }

PASSWORD_FORMAT = /\A
                  (?=.{8,})          # Must contain 8 or more characters
                  (?=.*\d)           # Must contain a digit
                  (?=.*[a-z])        # Must contain a lower case character
                  (?=.*[A-Z])        # Must contain an upper case character
                  (?=.*[[:^alnum:]]) # Must contain a symbol
                  /x

    validates :password_digest, 
                  presence: true, 
                  format: { with: PASSWORD_FORMAT } 

    validates :address, presence: true



    NUMBER_REGEX = /\d[0-9]\)*\z/


    validates :phone_number, presence: true,
                        length: { minimum:10, maximum:10},
                        format: {with: NUMBER_REGEX }


    
    has_secure_password
                        


end