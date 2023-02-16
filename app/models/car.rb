class Car < ApplicationRecord
    belongs_to :user
    has_many_attached :images
    has_one :order, dependent: :destroy
    
    validates :brand,
                presence: true

    validates :price,
                presence: true

    validates :color ,
                presence: true

    module FuelType
        PETROL = 0
        DIESEL = 1
        ETHANOL = 2
        ELECTRIC_BATTERY=3
        HYDROGEN=4

        FUEL_TYPE_NAME_MAP = {
            PETROL => "Petrol",
            DIESEL => "Diesel"
        }

        def self.all
            [PETROL, DIESEL, ETHANOL, ELECTRIC_BATTERY, HYDROGEN]
        end
    end

    module CarType 
        SUV=0
        HATCHBACK=1
        CROSSOVER=2
        CONVERTIBLE=3
        SEDAN=4
        SPORTS=5
        COUPE=6
        MINIVAN=7
        WAGON=8
        PICK_UP_TRUCK=9
    end

    module Condition 
        NEW =0
        SECOND_HAND=1
    end
    module Status
        AVAILABLE=0
        SOLD=1
    end
                
   def images_as_thumbnails
    images.map do |img|
        img.variant(resize_to_limit: [150,150]).processed

    end
   end
   validates :brand, 
                    presence: true

end