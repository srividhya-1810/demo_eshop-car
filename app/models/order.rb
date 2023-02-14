class Order < ApplicationRecord
    belongs_to :user
    belongs_to :car

    validates :brand,
                    presence: true

    validates :price,
                    presence: true
        
    validates :color ,
                    presence: true
end