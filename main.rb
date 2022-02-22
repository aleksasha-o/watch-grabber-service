# frozen_string_literal: true
require_relative 'services/browser'
require_relative 'services/parser'
require_relative 'services/processors/shop_hodinkee'

# @example = Browser.new(url: 'https://www.bobswatches.com/shop', tag: '.item form a').visit
# puts Parser.new(url: @example, tag: '.item form a')
#                         .parse_links
#                         .map { |item| "https://www.bobswatches.com/shop#{item}" }

puts "_______________________________________________________________________________"
puts Processors::ShopHodinkee.new.call
