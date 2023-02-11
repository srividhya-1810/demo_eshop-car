class User < ApplicationRecord
    has_many :cars
    before_save { self.email = email.downcase }


    
    has_secure_password
                        


end