# frozen_string_literal: true
require_relative 'base_model'

class ShopHodinkeeModel < BaseModel
  attr_accessor :water_resistance

  def initialize(**args)
    super
  end
end
