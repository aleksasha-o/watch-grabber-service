# frozen_string_literal: true
require 'nokogiri'
require 'open-uri'
require 'ferrum'

class GetProductsLinks
  RETRY_INTERVAL = 0.03
  TIMEOUT = 5

  class NotFoundError < StandardError; end

  def initialize(url:, tag:)
    @url = url
    @tag = tag
  end

  def parse_links_without_js
    doc = Nokogiri::HTML(URI.open(@url))
    doc.search(@tag).map { |link| "#{@url}#{link[:href]}" }
  end

  def parse_links_with_js
    browser
    @browser.go_to(@url)
    wait_for_element(@tag) do
      @browser.css(@tag).map { |link| "#{@url}#{link.attribute(:href)}" }
    end
  end

  protected

  def browser
    @browser ||= Ferrum::Browser.new
  end

  def wait_for_element(element_tag)
    load_time = 0
    begin
      raise NotFoundError unless @browser.at_css(element_tag)
      yield
    rescue NotFoundError
      sleep RETRY_INTERVAL
      load_time += RETRY_INTERVAL
      retry if load_time <= TIMEOUT
      raise "Couldn't find element #{element_tag} on #{@url}"
    end
  end
end
