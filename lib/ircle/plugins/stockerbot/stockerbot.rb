require 'rest-client'
require 'json'

class Stockerbot
  class InvalidSymbolException < Exception; end

  class RetriableException < Exception; end

  # TODO: Think about refactoring this so that we can rely on other services
  # besides yahoo ... it's a little flaky sometimes
  class YahooStockerService
    URL = "http://query.yahooapis.com/v1/public/yql"
    PARAMS = "format=json&env=store://datatables.org/alltableswithkeys"

    # Retry logic to deal with:
    #   1) random HTTP 400s from the yahoo service
    #   2) random responses lacking quote data
    def get_quote(symbol, retries=5)
      query = yql_query(clean_symbol(symbol))
      url = URI.encode("#{URL}?q=#{query}&#{PARAMS}")
      quote = nil
      while retries > 0 do
        begin
          quote = get url
          break unless is_retry? quote
        rescue Exception => e
          raise e
        end
        retries -= 1
      end
      if retries > 0
        raise InvalidSymbolException unless is_valid? quote
        format(quote)
      else
        raise "Could not get quote ... try again later"
      end
    end

    def clean_symbol(symbol)
      #TODO: make sure the symbol is clean to avoid sql injection type of things
      # this may not ever be important since the yahoo service seems to do a
      # decent job of restricting input
      symbol
    end

    def get(url)
      begin
        response = RestClient.get url
        # add a #json method to the response instance
        def response.json
          @json ||= JSON.load(self)
        end
        response
      rescue RestClient::Exception => e
        if e.response.code == 400
          # a special case since the service can throw a random 400 sometimes
          return e.response
        else
          raise e
        end
      end
    end

    def yql_query(symbol)
      # Use the google stock tables
      "select * from google.igoogle.stock where stock = '#{symbol}'"
    end

    def is_valid?(quote)
      quote.respond_to?(:json) && (!quote.json["query"]["results"]["xml_api_reply"]["finance"].has_key?("no_data_message"))
    end

    def format(quote)
      "#{field(quote, "last")} #{field(quote, "currency")} (#{field(quote, "company")}) [#{field(quote, "trade_timestamp")}] :: src=google.igoogle.stock"
    end

    def field(quote, field)
      quote.json["query"]["results"]["xml_api_reply"]["finance"][field]["data"]
    end

    def is_retry?(quote)
      quote.code == 400 || (quote.respond_to?(:json) && quote.json["query"]["count"].to_i == 0)
    end
  end

  include Cinch::Plugin
  include Ircle::Help

  HELP_SECTION = "stockerbot"
  HELP = "!stock <ticker> - get a stock quote"

  match(/stock (.+)/, :method => :get_quote, :react_on => :channel)
  match(/stock (.+)/, :method => :get_quote, :react_on => :private)

  def get_quote(message, stock_symbol)
    svc = YahooStockerService.new
    begin
      quote = svc.get_quote(stock_symbol)
      message.reply(quote)
    rescue InvalidSymbolException
      message.reply("Couldn't find symbol: #{stock_symbol}")
    rescue Exception => e # catches RestClient::Exception, too
      message.reply("Couldn't find the internet ... sorry, try again later")
      raise e
    end
  end
end
