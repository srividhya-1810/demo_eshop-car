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
                
   def images_as_thumbnails
    images.map do |img|
        img.variant(resize_to_limit: [150,150]).processed

    end
   end
   validates :brand, 
                    presence: true

end