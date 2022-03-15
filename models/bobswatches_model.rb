# frozen_string_literal: true

require_relative 'base_model'

class BobswatchesModel < BaseModel
  BOBSWATCHES_ATTRIBUTES = %i[box_and_papers year gender
                              condition regular_price].freeze
  attr_accessor(*BOBSWATCHES_ATTRIBUTES)

  def initialize(**args)
    super
    set_attributes(args, BOBSWATCHES_ATTRIBUTES)
  end
end
