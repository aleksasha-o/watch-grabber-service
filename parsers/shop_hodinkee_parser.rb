# frozen_string_literal: true
require 'nokogiri'
require_relative './base_parser'

class ShopHodinkeeParser < BaseParser
  def product_data
    print_full_data

    {
      brand: vendor,
      model: model,
      price: price
    }
  end

  def product_urls
    parse_links('.product-title')
  end

  def next_page_url
    parse_link('[aria-label="next page"]')
  end

  private

  # TODO: remove
  def print_full_data
    puts parse_content('.features__list ul li').map { |str| str.split(': ', 2) }.reject{ |pair| pair.size < 2 }.to_h
  end

  def vendor
    parse_content('.vendor')
  end

  def model
    parse_content('//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()')
  end

  def price
    parse_content('.price')
  end
end
