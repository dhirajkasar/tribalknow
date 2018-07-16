require 'json'
require 'faraday'

module Confluence
  module Api
    class Client
      attr_accessor :user, :pass, :url, :conn

      def initialize
        self.user = 'akshay.gore@coupa.com'
        self.pass = 'AIgJ6XNm7qSp5qYiFXjME68C'
        self.url  = 'https://coupadev.atlassian.net/wiki'
        self.conn = Faraday.new(url: url) do |faraday|
          faraday.request :url_encoded # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end
      end

      def get(params)
        response = conn.get('rest/api/search', params)
        JSON.parse(response.body)['results']
      end
    end
  end
end
