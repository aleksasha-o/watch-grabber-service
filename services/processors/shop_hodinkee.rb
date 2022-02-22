# frozen_string_literal: true
require_relative '../browser'
require_relative '../parser'
require_relative '../models/shop_hodinkee_model'

module Processors
  class ShopHodinkee
    def initialize(page: 1)
      @page = page
      @links = []
    end
    
    def call
      collect_links
      collect_data
    end

    private

    def collect_links
      page = "https://shop.hodinkee.com/collections/watches?page=#{@page}"
      puts "Parsing #{page}"
      opened_page = Browser.new(url: page, tag: '.product-title').visit
      parser = Parser.new(opened_page)
      parser.parse_links('.product-title').each do |item|
        link = "https://shop.hodinkee.com#{item}"
        @links << link unless @links.include?(link)
      end
      if parser.parse_link('[@aria-label="next page"]')
        @page += 1
        call
      end
    end

    def collect_data
      @links.map do |product_url|
        puts product_url
        @opened_item = Browser.new(url: product_url, tag: '.vendor').visit
        parser = Parser.new(@opened_item)
        @features = Models::ShopHodinkeeModel.new(brand: parser.parse_content('.vendor'),
                                                  model: parser.parse_content( '//*[@id="watch-pdp"]/div/div[1]/div/div[2]/div/h1/text()'),
                                                  price: parser.parse_content( '.price'))
        parser.parse_content('.features__list ul li').map { |str| str.split(': ', 2) }.reject{|pair| pair.size < 2 }.to_h
      end
    end

  end
end
