# frozen_string_literal: true
require_relative 'base_parser'

class ShopHodinkeeParser < BaseParser
  def attributes
    {
      brand: brand,
      model: model,
      price: price
    }
  end

  def item_urls
    parse_links('.product-title')
  end

  def next_page_exists?
    parse_link('[aria-label="next page"]')
  end

  private

  def brand
    parse_content_by_tag('.vendor')
  end

  def model
    parse_content_by_tag('//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()')
  end

  def price
    parse_content_by_tag('.price')
  end
end
