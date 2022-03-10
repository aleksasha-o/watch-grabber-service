# frozen_string_literal: true

require_relative './base_processor'
require_relative '../models/crownandcaliber_model'
require_relative '../parsers/crownandcaliber_parser'

class CrownandcaliberProcessor < BaseProcessor
  attr_accessor :page_content, :page

  HOST = 'https://www.crownandcaliber.com/'
  PAGINATION_SELECTOR = 'collections/shop-for-watches?page='

  def call
    visit_page
    parse_item_links
    visit_and_parse_items

    return browser.exit_browser unless page_parser.next_page_exists?

    @page += 1
    call
  end

  private

  def visit_page
    @page_content = browser.visit(url: "#{HOST}#{PAGINATION_SELECTOR}#{@page}", tag: '.card-title.ng-binding')
  end

  def parse_item_links
    @item_links = page_parser.item_urls
  end

  def page_parser
    CrownandcaliberParser.new(@page_content)
  end

  def visit_and_parse_items
    @item_links.each do |item_url|
      content = visit_item("https:#{item_url}")
      attributes = parse_item_attributes(content)

      puts CrownandcaliberModel.new(**attributes).inspect
    end
  end

  def visit_item(url)
    browser.visit(url: url, tag: '.vendor')
  end

  def parse_item_attributes(item_content)
    CrownandcaliberParser.new(item_content).attributes
  end
end
