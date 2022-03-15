# frozen_string_literal: true

require_relative 'base_parser'

class ShopHodinkeeParser < BaseParser
  TAGS = [
    ITEM = '.product-title',
    NEXT_PAGE = '[aria-label="next page"]',
    BRAND = '.vendor',
    MODEL = '//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()',
    PRICE = '.price',
    FEATURES = '.features__list ul li',
    BRACELET = :'bracelet/strap',
    RESISTANCE = :'water resistance',
    POWER = :'power reserve',
    LUG= :'lug width'
  ]

  # rubocop:disable Metrics/MethodLength
  def additional_attributes
    {
      crystal:          features[:crystal],
      water_resistance: features[RESISTANCE],
      reference_number: features[:reference],
      functions:        features[:functions],
      caseback:         features[:caseback],
      power_reserve:    features[POWER],
      manufactured:     features[:manufactured],
      lug_width:        features[LUG],
      lume:             features[:lume]
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def brand
    parse_content_by_tag(BRAND)[0]
  end

  def model
    features[:model]&.strip || parse_content_by_tag(MODEL)[0]&.strip
  end

  def dial_color
    features[:dial]
  end

  def case_material
    materials_array = [features[:material], features[:materials]].compact
    materials_array.join(' ') if materials_array.any?
  end

  def case_dimensions
    features[:dimensions]
  end

  def bracelet_material
    features[BRACELET]
  end

  def movement_type
    features[:caliber]
  end

  def features
    parse_content_by_tag(FEATURES)
      .map { |str| str.split(': ', 2) }
      .reject { |pair| pair.size < 2 }
      .to_h.transform_keys! { |key| key.downcase.to_sym }
  end
end
