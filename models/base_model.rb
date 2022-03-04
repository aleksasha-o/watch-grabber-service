# frozen_string_literal: true

class BaseModel
  ATTRIBUTES = %i[brand model price dial_color
                case_material case_diameter bracelet_material
                movement_type papers box year gender crystal]

  attr_accessor *ATTRIBUTES

  def initialize(**args)
    args.each { |key, value| instance_variable_set("@#{key}", value) if ATTRIBUTES.include?(key) }
  end
end
