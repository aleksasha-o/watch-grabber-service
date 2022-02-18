# frozen_string_literal: true
require_relative '../link_parsers/get_page'
require_relative '../link_parsers/links_parser'

class ShopHodinkee
  def links_list
    opened_page = GetPage.new(url: 'https://shop.hodinkee.com/collections/watches?page=1', tag: '.product-title')
                         .get_page
    LinksParser.new(url: opened_page, tag: '.product-title')
               .parse
               .map { |item| "https://shop.hodinkee.com#{item}" }
  end
end
