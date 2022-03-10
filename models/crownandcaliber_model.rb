# frozen_string_literal: true

require_relative 'base_model'

class CrownandcaliberModel < BaseModel
  CROWNANDCALIBER_ATTRIBUTES = %i[papers box year gender crystal condition caseback power_reserve
                                  lug_width bezel_material manual max_wrist_size case_thickness].freeze

  attr_accessor(*CROWNANDCALIBER_ATTRIBUTES)

  def initialize(**args)
    super
    set_attributes(args, CROWNANDCALIBER_ATTRIBUTES)
  end
end
