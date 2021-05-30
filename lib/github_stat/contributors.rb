module GithubStat
  class Contributors < GithubStat::Client

    SEARCH_BASE_URL = "search/issues"
    PER_PAGE = 30 # Limited for reduce execution time
    MAX_PAGE = 10

    def contributors_list(per_page = PER_PAGE)
      response = request(
        http_method: :get,
        endpoint: "repos/#{owner}/#{repo}/contributors?per_page=#{per_page}"
      )

      response.map { |c|
        {
          login: c['login'],
          id: c['id'],
          contributions: c['contributions']
        }
      }
    end

    # Variation of method for multiple page of contributors
    # All page parsing sometimes take a lot of time, average 1sec per author

    # def contributors_list(per_page = PER_PAGE)
    #   contributors = []

    #   for page in 1..MAX_PAGE
    #     response = request(
    #       http_method: :get,
    #       endpoint: "repos/#{owner}/#{repo}/contributors?per_page=#{per_page}&page=#{page}"
    #     )
    #     break if response.empty?
    #     contributors << response
    #   end

    #   contributors.flatten.map { |c|
    #     {
    #       login: c['login'],
    #       id: c['id'],
    #       contributions: c['contributions']
    #     }
    #   }
    # end

    def pulls_count(login)
      response = request(
        http_method: :get,
        endpoint: "#{SEARCH_BASE_URL}?q=repo:#{owner}/#{repo}+type:pr+is:open+is:closed+author:#{login}+created:#{start_date}..#{end_date}"
      )
      response['total_count'] || 0
    end

    def reviews_count(login)
      response = request(
        http_method: :get,
        endpoint: "#{SEARCH_BASE_URL}?q=repo:#{owner}/#{repo}+type:pr+is:open+is:closed+reviewed-by:#{login}+created:#{start_date}..#{end_date}"
      )
      response['total_count'] || 0
    end

    def comments_count(login)
      response = request(
        http_method: :get,
        endpoint: "#{SEARCH_BASE_URL}?q=repo:#{owner}/#{repo}+type:pr+is:open+is:closed+commenter:#{login}+created:#{start_date}..#{end_date}"
      )
      response['total_count'] || 0
    end
  end
end
