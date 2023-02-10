class Car < ApplicationRecord
    has_many_attached :images

   def images_as_thumbnails
    images.map do |img|
        img.variant(resize_to_limit: [150,150]).processed

    end
   end
   validates :brand, 
                    presence: true

end