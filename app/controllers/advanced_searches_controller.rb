class AdvancedSearchesController < SearchesController
  def index
  end
  
  def search
    @results = get_sphinx_search_results params[:q]
    @results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

    # confluence search API results
    # @results << confluence_api_results
    
    # github search API results
    # @results << jira_api_results

    # github search API results
    # @results << github_api_results
  end
end