# frozen_string_literal: true

module Models
  class BaseModel
    attr_accessor :brand, :model, :price, :sku, :dial_color,
                  :case_material, :case_diameter, :bracelet_material,
                  :movement_type, :papers, :box, :year,	:gender, :crystal

    def initialize(**args)
      args.each { |key, value| instance_variable_set("@#{key}", value) unless value.nil? }
    end
  end
end
