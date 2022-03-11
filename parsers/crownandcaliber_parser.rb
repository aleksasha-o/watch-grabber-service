# frozen_string_literal: true

require_relative 'base_parser'

class CrownandcaliberParser < BaseParser
  ITEM_TAG = '.grid-view-item__link'
  NEXT_PAGE_TAG = '.arrow.next:not(.disabled)'

  BRAND_TAG = '.vendor'
  MODEL_TAG = '.main-product-name'
  PRICE_TAG = '//*[@id="ProductPrice-product-template"]'
  CURRENCY = 'USD'

  FEATURES_TAG = '.prod-specs div'

  DIAL_TAG = 'dial color'
  CASE_MATERIAL_TAG = 'case material'
  DIMENSION_TAG = 'case size'
  CASEBACK_TAG = 'case back'
  POWER_TAG = 'power reserve'
  LUG_TAG = 'lug width'
  WRIST_TAG = 'max. wrist size'
  THICKNESS_TAG = 'case thickness'

  SPACE_EXPRESSION = /\s{2,}/

  # rubocop:disable Metrics/MethodLength
  def other_attributes
    {
      papers:         features[:papers],
      box:            features[:box],
      year:           features[:papers],
      gender:         features[:gender],
      crystal:        features[:crystal],
      condition:      features[:condition],
      caseback:       features[:CASEBACK_TAG],
      power_reserve:  features[:POWER_TAG],
      lug_width:      features[:LUG_TAG],
      bezel_material: features[:bezel],
      manual:         features[:manual],
      max_wrist_size: features[:WRIST_TAG],
      case_thickness: features[:THICKNESS_TAG]
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def model
    parse_content_by_tag(MODEL_TAG)[0]
  end

  def dial_color
    features[:DIAL_TAG]
  end

  def case_material
    features[:CASE_MATERIAL_TAG]
  end

  def case_dimensions
    features[:DIMENSION_TAG]
  end

  def bracelet_material
    features[:bracelet]
  end

  def movement_type
    features[:movement]
  end

  def features
    parse_html(FEATURES_TAG)
      .each { |item| item.children&.[](3)&.children&.[](1)&.remove }
      .map(&:content)
      .map { |str| str.split('- ', 2) }
      .reject { |pair| pair.size < 2 }
      .to_h { |key, value| [key.strip.downcase.to_sym, value&.strip&.gsub("\n", '')&.gsub(SPACE_EXPRESSION, ' ')] }
  end
end
