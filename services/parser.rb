# frozen_string_literal: true
require 'nokogiri'

class Parser
  def initialize(html)
    @html = html
  end

  def product_links(tag)
    Nokogiri::HTML(@html).search(tag).map { |link| link[:href] }
  end

  def parse_link(tag)
    product_links(tag)[0]
  end

  def parse_content_by_tag(tag)
    Nokogiri::HTML(@html).search(tag).map(&:content)
  end
end
