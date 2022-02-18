# frozen_string_literal: true
require_relative 'services/link_parsers/get_page'
require_relative 'services/link_parsers/links_parser'
require_relative 'services/shop_hodinkee/shop_hodinkee'

@example = GetPage.new(url: 'https://www.bobswatches.com/shop', tag: '.item form a').get_page
puts LinksParser.new(url: @example, tag: '.item form a')
                .parse
                .map { |item| 'https://www.bobswatches.com/shop' << item }

puts "_______________________________________________________________________________"
puts ShopHodinkee.new.links_list
