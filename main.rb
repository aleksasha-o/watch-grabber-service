# frozen_string_literal: true

require_relative 'processors/shop_hodinkee_processor'
require_relative 'processors/crownandcaliber_processor'
require_relative 'processors/bobswatches_processor'

ShopHodinkeeProcessor.call(page: 17)
CrownandcaliberProcessor.call(page: 49)
BobswatchesProcessor.call(page: 22)
