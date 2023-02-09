class User < ApplicationRecord
    before_save { self.email = email.downcase }

   

end