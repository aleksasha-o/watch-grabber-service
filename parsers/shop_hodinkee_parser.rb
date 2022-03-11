# frozen_string_literal: true

require_relative 'base_parser'

class ShopHodinkeeParser < BaseParser
  # rubocop:disable Metrics/MethodLength
  def attributes
    {
      brand:             brand,
      model:             features[:model],
      price:             price,
      dial_color:        features[:dial],
      case_material:     case_material,
      case_dimensions:   features[:dimensions],
      bracelet_material: features[:'bracelet/strap'],
      movement_type:     features[:caliber],
      crystal:           features[:crystal],
      water_resistance:  features[:'water resistance'],
      reference_number:  features[:reference],
      functions:         features[:functions],
      caseback:          features[:caseback],
      power_reserve:     features[:'power reserve'],
      manufactured:      features[:manufactured],
      lug_width:         features[:'lug width'],
      lume:              features[:lume]
    }
  end
  # rubocop:enable Metrics/MethodLength

  def item_urls
    parse_links('.product-title')
  end

  def next_page_exists?
    parse_link('[aria-label="next page"]')
  end

  private

  def brand
    parse_content_by_tag('.vendor')[0]
  end

  def price
    parse_content_by_tag('.price')[0]
  end

  def features
    parse_content_by_tag('.features__list ul li')
      .map { |str| str.split(': ', 2) }
      .reject { |pair| pair.size < 2 }
      .to_h.transform_keys! { |key| key.downcase.to_sym }
  end

  def case_material
    materials_array = [features[:material], features[:materials]].compact
    materials_array.join(' ') if materials_array.any?
  end
end
