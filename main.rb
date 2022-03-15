# frozen_string_literal: true

require_relative 'processors/shop_hodinkee_processor'
require_relative 'processors/crownandcaliber_processor'
require_relative 'processors/bobswatches_processor'

PROVIDERS = [
  ShopHodinkeeProcessor,
  CrownandcaliberProcessor,
  BobswatchesProcessor
].freeze

PROVIDERS.each(&:call)
