# frozen_string_literal: true
require_relative 'base_model'

module Models
  class ShopHodinkeeModel < BaseModel
    attr_accessor :water_resistance

    def initialize(**args)
      super
      @water_resistance = water_resistance
    end

  end
end
