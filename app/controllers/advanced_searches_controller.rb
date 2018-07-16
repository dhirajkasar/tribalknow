class AdvancedSearchesController < ApplicationController
  include ApiHelper

  def index
  end
  
  def search
    @q_results = []
    @q_results = get_sphinx_search_results params[:q]
    @q_results.map! do |result|
      label = if result.try(:name) && result.try(:description)
        "#{result.name}: #{result.description}"
      else
        result.title[0..25].gsub(/\s\w+$/,'...')
      end
      {
        label: label,
        source: "Q",
        category: result.class.model_name.human,
        url: resource_url(result)
      }
    end
    @q_results = @q_results.group_by{ |d| d[:category] }
    @confluence_results = []
    if params[:confluence] == "1"
      conn = Confluence::Api::Client.new
      api_results = conn.get({"cql"=>"text~#{params[:q]}"} )
      api_results.each do |result|
        @confluence_results << {
          label: result['content']['title'],
          source: "Confluence",
          category: result['content']['_expandable']['space'].gsub!("/rest/api/space/", ""),
          subcategory: result['content']['type'],
          url: "https://coupadev.atlassian.net/wiki" + result['content']['_links']['webui']
        }
      end
      @confluence_results = @confluence_results.group_by{ |d| d[:subcategory] }
    end
    
    @jira_results = []
    
    if params[:jira] == "1"
      conn = JIRA::Api::Client.new
      api_results = conn.get({"jql"=>"summary~#{params[:q]} AND project=CD"} )
      api_results.each do |result|
        @jira_results << {
          label: result['key'] + ": " + result['fields']['summary'],
          source: "JIRA",
          category: result['fields']['project']['name'],
          url: "https://coupadev.atlassian.net/browse/" + result['key']
        }
      end
    end
  end
end