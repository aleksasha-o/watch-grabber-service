# frozen_string_literal: true
require 'nokogiri'

class BaseParser
  def initialize(html)
    @html = html
  end

  def product_data
    raise NotImplementedError, 'Method #parse_product_data has to be implemented!'
  end

  def product_urls
    raise NotImplementedError, 'Method #parse_product_links has to be implemented!'
  end

  def next_page_url
    raise NotImplementedError, 'Method #parse_next_page_link has to be implemented!'
  end

  private

  def parse_links(tag)
    Nokogiri::HTML(@html).search(tag).map { |link| link[:href] }
  end

  def parse_link(tag)
    parse_links(tag)[0]
  end

  def parse_content(tag)
    Nokogiri::HTML(@html).search(tag).map(&:content)
  end
end
