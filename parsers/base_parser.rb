# frozen_string_literal: true
require 'nokogiri'

class BaseParser
  def initialize(html)
    @html = html
  end

  def attributes
    raise NotImplementedError, 'Method #attributes has to be implemented!'
  end

  def item_urls
    raise NotImplementedError, 'Method #attributes has to be implemented!'
  end

  def next_page_exists?
    raise NotImplementedError, 'Method #attributes has to be implemented!'
  end

  private

  def parse_links(tag)
    Nokogiri::HTML(@html).search(tag).map { |link| link[:href] }
  end

  def parse_link(tag)
    parse_links(tag)[0]
  end

  def parse_content_by_tag(tag)
    Nokogiri::HTML(@html).search(tag).map(&:content)
  end
end
