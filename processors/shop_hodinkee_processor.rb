# frozen_string_literal: true

require_relative './base_processor'
require_relative '../models/shop_hodinkee_model'
require_relative '../parsers/shop_hodinkee_parser'

class ShopHodinkeeProcessor < BaseProcessor
  TAGS = [
    PAGE = '.product-title',
    ITEM = '.vendor'
  ]

  HOST = 'https://shop.hodinkee.com/'
  PAGINATION_SELECTOR = 'collections/watches?page='

  private

  def page_url
    "#{HOST}#{PAGINATION_SELECTOR}#{@page}"
  end

  def parser
    ShopHodinkeeParser
  end

  def full_item_url(path)
    "#{HOST}#{path}"
  end

  def model
    ShopHodinkeeModel
  end
end
