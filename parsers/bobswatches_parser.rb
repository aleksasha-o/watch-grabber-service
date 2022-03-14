# frozen_string_literal: true

require_relative 'base_parser'

class BobswatchesParser < BaseParser
  ITEM_TAG = '.item form a'
  NEXT_PAGE_TAG = '.categoryPaginationButtonNextLast a[href]'

  MODEL_TAG = :'model name/number'
  PRICE_TAG = '[itemprop="price"]'

  FEATURES_TAG = '.descriptioncontainer table'
  BOX_TAG_1 = :'box & papers'
  BOX_TAG_2 = :'box and papers'
  YEAR_TAG = :'serial/year'
  CONDITON_TAG = :"condition (what's this?)"
  REGULAR_PRICE_TAG = :"\nregular price"

  def additional_attributes
    {
      box_and_papers: box_papers,
      year:           year,
      gender:         features[:gender],
      condition:      features[CONDITON_TAG],
      regular_price:  features[REGULAR_PRICE_TAG]
    }
  end

  private

  def brand
    features[:brand]
  end

  def model
    features[MODEL_TAG]
  end

  def dial_color
    features[:dial]
  end

  def case_material
    features[:case]
  end

  def case_dimensions
    features[:case]&.scan(/\d+mm/)&.join
  end

  def bracelet_material
    features[:bracelet]
  end

  def movement_type
    features[:movement]
  end

  def box_papers
    features[BOX_TAG_1] || features[BOX_TAG_2]
  end

  def year
    features[YEAR_TAG]&.scan(/\d{2,}$/)&.join
  end

  def features
    features_hash = {}
    parse_html(FEATURES_TAG).each do |table|
      table.search('tr').each do |row|
        node = row.children.reject { |elem| elem.content == ' ' || elem.content == "\n" }
        features_hash[node.first.content.delete!(':')&.strip&.downcase&.to_sym] = node.last.content&.strip
      end
    end
    features_hash
  end
end
