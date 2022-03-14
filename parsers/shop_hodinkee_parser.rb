# frozen_string_literal: true

require_relative 'base_parser'

class ShopHodinkeeParser < BaseParser
  ITEM_TAG = '.product-title'
  NEXT_PAGE_TAG = '[aria-label="next page"]'

  BRAND_TAG = '.vendor'
  MODEL_TAG = '//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()'
  PRICE_TAG = '.price'

  FEATURES_TAG = '.features__list ul li'

  BRACELET_TAG = :'bracelet/strap'
  RESISTANCE_TAG = :'water resistance'
  POWER_TAG = :'power reserve'
  LUG_TAG = :'lug width'

  # rubocop:disable Metrics/MethodLength
  def additional_attributes
    {
      crystal:          features[:crystal],
      water_resistance: features[RESISTANCE_TAG],
      reference_number: features[:reference],
      functions:        features[:functions],
      caseback:         features[:caseback],
      power_reserve:    features[POWER_TAG],
      manufactured:     features[:manufactured],
      lug_width:        features[LUG_TAG],
      lume:             features[:lume]
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def brand
    parse_content_by_tag(BRAND_TAG)[0]
  end

  def model
    features[:model]&.strip || parse_content_by_tag(MODEL_TAG)[0]&.strip
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
    features[BRACELET_TAG]
  end

  def movement_type
    features[:caliber]
  end

  def features
    parse_content_by_tag(FEATURES_TAG)
      .map { |str| str.split(': ', 2) }
      .reject { |pair| pair.size < 2 }
      .to_h.transform_keys! { |key| key.downcase.to_sym }
  end
end
