# frozen_string_literal: true
require_relative './base_processor'
require_relative '../models/shop_hodinkee_model'
require_relative '../parsers/shop_hodinkee_parser'

class ShopHodinkeeProcessor < BaseProcessor
  attr_accessor :page_content, :page

  HOST = 'https://shop.hodinkee.com/'
  PAGINATION_SELECTOR = 'collections/watches?page='

  def call
    visit_page
    parse_item_links
    visit_and_parse_items

    return browser.exit_browser unless page_parser.next_page_exists?

    @page += 1
    call
  end

  private

  def visit_page
    @page_content = browser.visit(url: "#{HOST}#{PAGINATION_SELECTOR}#{@page}", tag: '.product-title')
  end

  def parse_item_links
    @item_links = page_parser.item_urls
  end

  def page_parser
    ShopHodinkeeParser.new(@page_content)
  end

  def visit_and_parse_items
    @item_links.each do |item_url|
      content = visit_item(item_url)
      attributes = parse_item_attributes(content)

      puts ShopHodinkeeModel.new(**attributes).inspect
    end
  end

  def visit_item(url)
    browser.visit(url: "#{HOST}#{url}", tag: '.vendor')
  end

  def parse_item_attributes(item_content)
    ShopHodinkeeParser.new(item_content).attributes
  end
end
