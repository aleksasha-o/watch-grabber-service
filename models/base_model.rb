# frozen_string_literal: true

class BaseModel
  ATTRIBUTES = %i[brand model price dial_color case_material
                  case_dimensions bracelet_material movement_type].freeze

  attr_accessor(*ATTRIBUTES)

  def initialize(**args)
    set_attributes(args, ATTRIBUTES)
  end

  private

  def set_attributes(args, attribute_names)
    args.each { |key, value| instance_variable_set("@#{key}", value) if attribute_names.include?(key) }
  end
end
