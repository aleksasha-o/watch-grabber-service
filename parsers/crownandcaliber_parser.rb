# frozen_string_literal: true

require_relative 'base_parser'

class CrownandcaliberParser < BaseParser
  SPACE_EXPRESSION = /\s{2,}/

  # rubocop:disable Metrics/MethodLength
  def attributes
    {
      brand:             brand,
      model:             model,
      price:             price,
      dial_color:        features[:'dial color'],
      case_material:     features[:'case material'],
      case_dimensions:   features[:'case size'],
      bracelet_material: features[:bracelet],
      movement_type:     features[:movement],
      papers:            features[:papers],
      box:               features[:box],
      year:              features[:papers],
      gender:            features[:gender],
      crystal:           features[:crystal],
      condition:         features[:condition],
      caseback:          features[:'case back'],
      power_reserve:     features[:'power reserve'],
      lug_width:         features[:'lug width'],
      bezel_material:    features[:'lug width'],
      manual:            features[:manual],
      max_wrist_size:    features[:'max. wrist size'],
      case_thickness:    features[:'case thickness']
    }
  end
  # rubocop:enable Metrics/MethodLength

  def item_urls
    parse_links('.grid-view-item__link')
  end

  def next_page_exists?
    parse_html('.arrow.next:not(.disabled)')[0]
  end

  private

  def brand
    parse_content_by_tag('.vendor')[0]
  end

  def model
    parse_content_by_tag('.main-product-name')[0]
  end

  def price
    parse_content_by_tag('//*[@id="ProductPrice-product-template"]')[0]&.scan(PRICE_EXPRESSION)&.join
  end

  def features
    parse_html('.prod-specs div')
      .each { |item| item.children&.[](3)&.children&.[](1)&.remove }
      .map(&:content)
      .map { |str| str.split('- ', 2) }
      .reject { |pair| pair.size < 2 }
      .to_h { |key, value| [key.strip.downcase.to_sym, value&.strip&.gsub("\n", '')&.gsub(SPACE_EXPRESSION, ' ')] }
  end
end
