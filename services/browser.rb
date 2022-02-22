# frozen_string_literal: true
require 'ferrum'

class Browser
  RETRY_INTERVAL = 0.03
  TIMEOUT = 5

  class NotFoundError < StandardError; end

  def initialize(url:, tag:)
    @url = url
    @tag = tag
  end

  def visit
    browser.go_to(@url)
    wait_for_element

    save_body
    browser.quit

    @body
  end

  private

  def browser
    @browser ||= Ferrum::Browser.new(timeout: 15)
  end

  def wait_for_element
    load_time = 0
    begin
      raise NotFoundError unless @browser.at_css(@tag)
    rescue NotFoundError
      sleep RETRY_INTERVAL
      load_time += RETRY_INTERVAL
      retry if load_time <= TIMEOUT
      raise "Couldn't find element #{@tag} on #{@url}"
    end
  end

  def save_body
    @body = browser.body
  end
end
