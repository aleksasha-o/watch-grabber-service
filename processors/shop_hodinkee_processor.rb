# frozen_string_literal: true
require_relative './base_processor'
require_relative '../models/shop_hodinkee_model'

class ShopHodinkeeProcessor < BaseProcessor
  HOST = 'https://shop.hodinkee.com'
  PAGINATION_SELECTOR = '/collections/watches?page='

  def call
    full_url = "#{HOST}#{PAGINATION_SELECTOR}#{@page}"
    page_content = browser.visit(url: full_url, tag: '.product-title')

    items_urls = parser(content: page_content).product_links('.product-title')
    items_urls.each do |item_url|
      full_item_url = "#{HOST}#{item_url}"

      item_content = browser.visit(url: full_item_url, tag: '.vendor')
      puts attrs = parser(content: item_content).parse_content_by_tag('.features__list ul li')
                                                .map { |str| str.split(': ', 2) }
                                                .reject{ |pair| pair.size < 2 }
                                                .to_h
      @features = ShopHodinkeeModel.new(
        brand: parser(content: item_content).parse_content_by_tag('.vendor'),
        model: parser(content: item_content).parse_content_by_tag('//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()'),
        price: parser(content: item_content).parse_content_by_tag('.price')
      )
    end

    return browser.exit_browser unless parser(content: page_content).parse_link('[aria-label="next page"]')

    @page += 1
    call
  end
end
