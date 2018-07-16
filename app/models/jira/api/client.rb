require 'json'
require 'faraday'

module JIRA
  module Api
    class Client
      attr_accessor :user, :pass, :url, :conn, :count, :results

      def initialize
        self.user = 'akshay.gore@coupa.com'
        self.pass = 'AIgJ6XNm7qSp5qYiFXjME68C'
        self.url = "https://coupadev.atlassian.net/"
        self.conn = Faraday.new(url: url) do |faraday|
          faraday.request :url_encoded # form-encode POST params
          # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(self.user, self.pass)
        end
      end

      def get(params)
        response = conn.get('rest/api/2/search', params)
        # self.count = JSON.parse(response.body)['total']
        # self.results = JSON.parse(response.body)['issues']
        # link = "https://coupadev.atlassian.net/issues?jql="+params["jql"]
        JSON.parse(response.body)["issues"]
      end

      def project_based_jira_list(results)
        projects = {}
        results.each do |issue|
          projects.key?(issue["fields"]["project"]["name"])? projects[issue["fields"]["project"]["name"]] +=1 : projects[issue["fields"]["project"]["name"]]=1
          #https://coupadev.atlassian.net/rest/api/2/search?jql=text~%22mysql%22%20AND%20project%3D%22CD%22
        end
        #binding.pry
      end
    end
  end
end
