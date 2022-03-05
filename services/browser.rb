# frozen_string_literal: true
require 'ferrum'

class Browser
  attr_accessor :tag, :body

  RETRY_INTERVAL = 0.03
  TIMEOUT = 5
  FORMATS = /\.png|\.jpg|\.jpeg|\.svg|\.woff2/

  class NotFoundError < StandardError; end

  def visit(url:, tag:)
    browser.network.intercept
    browser.on(:request) { |request| !request.match?(FORMATS) ? request.continue : request.abort }
    browser.go_to(url)
    wait_for_element

    browser.body
  end

  def exit_browser
    browser.quit
  end

  private

  def browser
    @browser ||= Ferrum::Browser.new(pending_connection_errors: false)
  end

  def wait_for_element
    load_time = 0
    begin
      raise NotFoundError if @browser.at_css(tag).nil?
    rescue NotFoundError, Ferrum::NodeNotFoundError
      sleep RETRY_INTERVAL
      load_time += RETRY_INTERVAL
      retry if load_time <= TIMEOUT
      end
    end

  def body
    @body = browser.body
  end
end
