# frozen_string_literal: true
require_relative 'base_model'

class ShopHodinkeeModel < BaseModel
  HODINKEE_ATTRIBUTES = %i[crystal water_resistance reference_number functions
                           caseback power_reserve manufactured lug_width lume]

  attr_accessor *HODINKEE_ATTRIBUTES

  def initialize(**args)
    super
    set_attributes(args, HODINKEE_ATTRIBUTES)
  end
end
