# frozen_string_literal: true
require_relative './base_processor'
require_relative '../models/shop_hodinkee_model'

class ShopHodinkeeProcessor < BaseProcessor
  attr_accessor :content, :item_content, :page

  HOST = 'https://shop.hodinkee.com'
  PAGINATION_SELECTOR = '/collections/watches?page='

  def call
    visit_page
    parse_item_urls
    parse_items

    return browser.exit_browser unless next_page

    @page += 1
    call
  end

  private

  def visit_page
    @content = browser.visit(url: "#{HOST}#{PAGINATION_SELECTOR}#{@page}", tag: '.product-title')
  end

  def parse_item_urls
    @item_urls = parser(@content).parse_links('.product-title')
  end

  def parse_items
    @item_urls.each do |item_url|
      item_content = visit_item(item_url)
      ShopHodinkeeModel.new(**parse_item_attributes(item_content))
    end
  end

  def visit_item(url)
    @item_content = browser.visit(url: "#{HOST}#{url}", tag: '.vendor')
  end

  def parse_item_attributes(content)
    item_parser = parser(content)

    {
      brand: item_parser.parse_content_by_tag('.vendor').join,
      model: item_parser.parse_content_by_tag('//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()').join,
      price: item_parser.parse_content_by_tag('.price').join
    }
  end

  def next_page
    parser(@content).parse_link('[aria-label="next page"]')
  end
end
