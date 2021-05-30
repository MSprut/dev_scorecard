class Scorecard::Creator

  MOST_RATED = 5
  PULL_POINTS = 12
  REVIEW_POINTS = 3
  COMMENT_POINTS = 1

  def initialize(owner, repo, start_date = nil, end_date = nil)
    @owner = owner
    @repo = repo
    @start_date = start_date
    @end_date = end_date
  end

  def create
    client = create_client
    contributors = get_contributors(client)
    current_repo = save_repo
    save_contributors(current_repo, contributors)
    save_statistics(client, current_repo)
  end

  private

  attr_reader :owner, :repo, :start_date, :end_date, :client

  def create_client
    ::GithubStat::Contributors.new(owner, repo, start_date, end_date)
  end

  def get_contributors(client)
    client.contributors_list
  end

  def save_repo
    Repo.where(owner: owner, repo: repo).first_or_create
  end

  def save_contributors(current_repo, contributors)
    contributors_github_ids = contributors.map { |c| c[:id] }
    existing_contributors_ids = current_repo.contributors.where(github_id: contributors_github_ids).pluck(:github_id)
    not_existing_ids = contributors_github_ids - existing_contributors_ids
    new_contributors = contributors&.select{ |c| not_existing_ids.include?(c[:id]) }

    new_contributors.each do |c|
      attrs = c.merge(github_id: c[:id]).except(:id)
      current_repo.contributors.create(attrs)
    end
  end

  def save_statistics(client, current_repo)
    statistics = []
    current_repo.contributors.each do |c|
      pulls_count = client.pulls_count(c.login) * PULL_POINTS
      reviews_count = client.reviews_count(c.login) * REVIEW_POINTS
      comments_count = client.comments_count(c.login) * COMMENT_POINTS
      # Here should be a logic for saving statistic to the PullStatistic model
      # This part was simplified because due to lack of requirements
      statistics << { author: c.login, pulls: pulls_count, reviews: reviews_count, comments: comments_count }
    end
    show_statistics(statistics)
  end

  def show_statistics(statistics)
    statistics = statistics.map { |i|
      i.merge(rate: i.except(:author).inject(0) { |a, (_, v)| a + v } / 3)
    }.sort_by { |k, v| k[:rate] }.reverse.first(MOST_RATED)
    puts Hirb::Helpers::Table.render(statistics)
  end
end
