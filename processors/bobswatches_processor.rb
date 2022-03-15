# frozen_string_literal: true

require_relative './base_processor'
require_relative '../models/bobswatches_model'
require_relative '../parsers/bobswatches_parser'

class BobswatchesProcessor < BaseProcessor
  TAGS = [
    PAGE = '.product-title',
    ITEM = '.price'
  ]

  HOST = 'https://www.bobswatches.com/'
  PAGINATION_SELECTOR = 'shop?page='

  private

  def page_url
    "#{HOST}#{PAGINATION_SELECTOR}#{@page}"
  end

  def parser
    BobswatchesParser
  end

  def full_item_url(path)
    "#{HOST}#{path}"
  end

  def model
    BobswatchesModel
  end
end
