# frozen_string_literal: true
require 'ferrum'

class Browser
  RETRY_INTERVAL = 0.03
  TIMEOUT = 5

  class NotFoundError < StandardError; end

  def visit(url:, tag:)
    @tag = tag
    @load_time = 0

    browser.network.intercept
    browser.on(:request) do |request|
      next request.abort if request.match?(/\.png|\.jpg|\.jpeg|\.svg|\.woff2/)

      request.continue
    end
    browser.go_to(url)
    wait_for_element

    body
    browser.quit

    @body
  end

  private

  def browser
    @browser ||= Ferrum::Browser.new(pending_connection_errors: false)
  end

  def wait_for_element
    raise NotFoundError if @browser.at_css(@tag).nil?
  rescue NotFoundError, Ferrum::NodeNotFoundError
    sleep RETRY_INTERVAL
    @load_time += RETRY_INTERVAL
    retry if @load_time <= TIMEOUT
  end

  def body
    @body = browser.body
  end
end
