module GithubStat
  class Client

    GITHUB_BASE_URL = "https://api.github.com/"
    DATE_FORMAT = '%Y-%m-%d'

    def initialize(owner, repo, start_date = last_week_dates.first, end_date = last_week_dates.last)
      @owner = owner
      @repo = repo
      @start_date = start_date
      @end_date = end_date
    end

    private

    attr_accessor :owner, :repo, :start_date, :end_date

    def client
      @_client ||= Faraday.new(GITHUB_BASE_URL) do |client|
        client.adapter Faraday.default_adapter
        client.headers['Content-Type'] = "application/json"
      end
    end

    def request(http_method:, endpoint:, params: {})
      response = client.public_send(http_method, endpoint, (params.to_json unless params.empty?))
      Oj.load(response.body)
    end

    def last_week_dates
      return Date.today.last_week.beginning_of_week.strftime(DATE_FORMAT), Date.today.last_week.at_end_of_week.strftime(DATE_FORMAT)
    end
  end
end
