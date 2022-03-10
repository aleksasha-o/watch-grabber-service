# frozen_string_literal: true

require_relative '../services/browser'

class BaseProcessor
  def initialize(page: 1)
    @page = page
  end

  def self.call(page: 1)
    new(page: page).call
  end

  def call
    raise NotImplementedError, 'Method #call has to be implemented!'
  end

  private

  def browser
    @browser ||= Browser.new
  end
end
