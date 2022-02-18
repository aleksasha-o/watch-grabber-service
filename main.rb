# frozen_string_literal: true

require_relative 'services/products_links/get_products_links'

@example = GetProductsLinks.new(url: "https://www.bobswatches.com/shop", tag: '.item form a')
@example2 = GetProductsLinks.new(url: 'https://www.chronext.com/buy', tag: '.product-tile .product-tile__wrapper > *:last-child')
puts @example.parse_links_with_js
puts @example2.parse_links_without_js
