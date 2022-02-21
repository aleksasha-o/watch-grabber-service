# frozen_string_literal: true
require 'nokogiri'

class Parser
  def initialize(url:, tag:)
    @url = url
    @tag = tag
  end

  def parse_links
    @doc = Nokogiri::HTML(@url)
    @doc.search(@tag).map { |link| link[:href] }
  end
end
