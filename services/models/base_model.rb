# frozen_string_literal: true

module Models
  class BaseModel
    attr_accessor :brand, :model, :price, :sku, :dial_color,
                  :case_material, :case_diameter, :bracelet_material,
                  :movement_type, :papers, :box, :year,	:gender, :crystal

    def initialize(**args)
      @brand = brand
      @model = model
      @price = price
      @case_material = case_material
    end
  end
end
