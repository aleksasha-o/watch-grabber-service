# frozen_string_literal: true
require_relative '../services/browser'
require_relative '../parsers/shop_hodinkee_parser'
require_relative '../models/shop_hodinkee_model'

module Processors
  class ShopHodinkee
    HOST = 'https://shop.hodinkee.com'
    PAGINATION_SELECTOR = '/collections/watches?page='

    def initialize(page: 1)
      @page = page
    end

    def self.call
      new.call
    end

    def call
      list_page = browser.visit(url: "#{HOST}#{PAGINATION_SELECTOR}#{@page}", tag: '.product-title')
      parser = ShopHodinkeeParser.new(list_page)

      parser.product_urls.each { |url| build_product(url) }

      return unless parser.next_page_url

      @page += 1
      call
    end

    private

    def browser
      @browser = Browser.new
    end

    def build_product(product_url)
      product_page = browser.visit(url: "#{HOST}#{product_url}", tag: '.vendor')

      data = ShopHodinkeeParser.new(product_page).product_data
      @features = Models::ShopHodinkeeModel.new(**data)
    end
  end
end
