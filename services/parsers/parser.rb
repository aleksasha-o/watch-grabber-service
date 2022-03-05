# frozen_string_literal: true
require 'nokogiri'

module Parsers
  class Parser
    def initialize(html)
      @html = html
    end

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
end
