# frozen_string_literal: true

require_relative 'base_parser'

class BobswatchesParser < BaseParser
  TAGS = [
    ITEM = '.item form a',
    NEXT_PAGE = '.categoryPaginationButtonNextLast a[href]',
    MODEL = :'model name/number',
    PRICE = '[itemprop="price"]',
    FEATURES = '.descriptioncontainer table',
    BOX_1 = :'box & papers',
    BOX_2 = :'box and papers',
    YEAR = :'serial/year',
    CONDITION = :"condition (what's this?)",
    REGULAR_PRICE = :"\nregular price"
  ]

  def additional_attributes
    {
      box_and_papers: box_papers,
      year:           year,
      gender:         features[:gender],
      condition:      features[CONDITION],
      regular_price:  features[REGULAR_PRICE]
    }
  end

  private

  def brand
    features[:brand]
  end

  def model
    features[MODEL]
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
    features[BOX_1] || features[BOX_2]
  end

  def year
    features[YEAR]&.scan(/\d{2,}$/)&.join
  end

  def features
    features_hash = {}
    parse_html(FEATURES).each do |table|
      table.search('tr').each do |row|
        node = row.children.reject { |elem| elem.content == ' ' || elem.content == "\n" }
        features_hash[node.first.content.delete!(':')&.strip&.downcase&.to_sym] = node.last.content&.strip
      end
    end
    features_hash
  end
end
