# frozen_string_literal: true
require 'nokogiri'

class LinksParser
  def initialize(url:, tag:)
    @url = url
    @tag = tag
  end

  def parse
    @doc = Nokogiri::HTML(@url)
    @doc.search(@tag).map { |link| link[:href] }
  end
end
