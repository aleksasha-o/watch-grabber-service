# frozen_string_literal: true

require_relative './base_processor'
require_relative '../models/crownandcaliber_model'
require_relative '../parsers/crownandcaliber_parser'

class CrownandcaliberProcessor < BaseProcessor
  PAGE_TAG = '.card-title.ng-binding'
  ITEM_TAG = '.vendor'

  PROTOCOL = 'https:'
  HOST = '//www.crownandcaliber.com/'
  PAGINATION_SELECTOR = 'collections/shop-for-watches?page='

  private

  def page_url
    "#{PROTOCOL}#{HOST}#{PAGINATION_SELECTOR}#{@page}"
  end

  def parser
    CrownandcaliberParser
  end

  def full_item_url(part_of_url)
    "#{PROTOCOL}#{part_of_url}"
  end

  def model
    CrownandcaliberModel
  end
end
