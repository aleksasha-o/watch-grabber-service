# frozen_string_literal: true
require_relative '../browser'
require_relative '../parser'
require_relative '../models/shop_hodinkee_model'

module Processors
  class ShopHodinkee
    HOST = 'https://shop.hodinkee.com'
    PAGINATION_SELECTOR = '/collections/watches?page='

    def initialize(page: 1)
      @page = page
    end
    
    def call
      full_url = "#{HOST}#{PAGINATION_SELECTOR}#{@page}"
      puts "Parsing #{full_url}"

      content = browser.visit(url: full_url, tag: '.product-title')
      items_collection = parser(content: content).parse_links('.product-title')
      items_collection.each do |item_page|
        puts item_url = "#{HOST}#{item_page}"
        item_content = browser.visit(url: item_url, tag: '.vendor')
        puts attrs = parser(content: item_content).parse_content_by_tag('.features__list ul li').map { |str| str.split(': ', 2) }.reject{|pair| pair.size < 2 }.to_h
        @features = Models::ShopHodinkeeModel.new(brand: parser(content: item_content).parse_content_by_tag('.vendor'),
                                                  model: parser(content: item_content).parse_content_by_tag('//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()'),
                                                  price: parser(content: item_content).parse_content_by_tag('.price'))
        puts "Brand #{@features.brand} Model #{@features.model} Price #{@features.price}"
      end
      if @parser.parse_link('[aria-label="next page"]')
        @page += 1
        call
      end
    end

    private

    def browser
      @browser = Browser.new
    end

    def parser(content:)
      @parser = Parser.new(content)
    end

  end
end
