# frozen_string_literal: true

require 'nokogiri'

class BaseParser
  PRICE_EXPRESSION = /\d+(?:,\d+)?/
  CURRENCY = 'USD'

  attr_reader :engine

  def initialize(html)
    @engine = Nokogiri::HTML(html)
  end

  def attributes
    base_attributes.merge!(additional_attributes)
  end

  # rubocop:disable Metrics/MethodLength
  def base_attributes
    {
      brand:             brand,
      model:             model,
      price:             price,
      currency:          CURRENCY,
      dial_color:        dial_color,
      case_material:     case_material,
      case_dimensions:   case_dimensions,
      bracelet_material: bracelet_material,
      movement_type:     movement_type
    }
  end
  # rubocop:enable Metrics/MethodLength

  def item_urls
    parse_links(self.class::ITEM_TAG)
  end

  def next_page?
    parse_link(self.class::NEXT_PAGE_TAG)
  end

  private

  def parse_links(tag)
    parse_html(tag).map { |link| link[:href] }
  end

  def parse_link(tag)
    parse_links(tag)[0]
  end

  def parse_content_by_tag(tag)
    parse_html(tag).map(&:content)
  end

  def parse_html(tag)
    engine.search(tag)
  end

  def price
    parse_content_by_tag(self.class::PRICE_TAG)[0]&.scan(PRICE_EXPRESSION)&.join
  end
end
