# frozen_string_literal: true
require_relative '../browser'
require_relative '../parser'

module WebSites
  class ShopHodinkee
    def links_list
      opened_page = Browser.new(url: 'https://shop.hodinkee.com/collections/watches?page=1', tag: '.product-title')
                           .visit
      Parser.new(url: opened_page, tag: '.product-title')
                 .parse_links
                 .map { |item| "https://shop.hodinkee.com#{item}" }
    end
  end
end
