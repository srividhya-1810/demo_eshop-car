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

                
   def images_as_thumbnails
    images.map do |img|
        img.variant(resize_to_limit: [150,150]).processed

    end
   end
   validates :brand, 
                    presence: true

end