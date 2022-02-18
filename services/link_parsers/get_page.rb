# frozen_string_literal: true
require 'ferrum'

class GetPage
  RETRY_INTERVAL = 0.03
  TIMEOUT = 5

  class NotFoundError < StandardError; end

  def initialize(url:, tag:)
    @url = url
    @tag = tag
  end

  def get_page
    browser
    @browser.go_to(@url)
    wait_for_element(@tag)
    @browser.body
  end

  protected

  def browser
    @browser ||= Ferrum::Browser.new
  end

  def wait_for_element(element_tag)
    load_time = 0
    begin
      raise NotFoundError unless @browser.at_css(element_tag)
    rescue NotFoundError
      sleep RETRY_INTERVAL
      load_time += RETRY_INTERVAL
      retry if load_time <= TIMEOUT
      raise "Couldn't find element #{element_tag} on #{@url}"
    end
  end
end
