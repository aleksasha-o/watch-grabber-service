# frozen_string_literal: true
require_relative 'services/browser'
require_relative 'services/parser'
require_relative 'services/processors/shop_hodinkee'

puts Processors::ShopHodinkee.new.call
