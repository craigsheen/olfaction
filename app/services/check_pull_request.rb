class CheckPullRequest
  attr_reader :files, :repo, :id, :pull_request_comments

  def initialize(repo, id)
    @repo = repo
    @id = id
    @files = []
    @reek_output = []
    @pull_request_comments = []
  end

  def execute
    build_directory_for_temp_files
    fetch_files_from_github
    delete_previously_generated_comments
    run_reek
    send_results_to_github
    clean_up
    create_stored_pull_request
  end

  def directory_path
    "#{Rails.root}/tmp/#{repo}/#{id}"
  end

  def pull_request_url
    "https://github.com/#{repo}/pull/#{id}"
  end

  def pull_request_api_url
    "https://api.github.com/repos/#{repo}/pulls/#{id}"
  end

  def files_url
    "#{pull_request_api_url}/files"
  end

  def comments_url(access_token: true, comment_id: nil)
    comment_url = "#{pull_request_api_url}/comments"
    comment_url += "/#{comment_id}" unless comment_id.blank?
    comment_url += access_token_as_param if access_token
    comment_url
  end

  def access_token_as_param
    "?access_token=#{KeyVault[:access_token]}"
  end

  private

  attr_writer :files, :current_comments

  def build_directory_for_temp_files
    `mkdir -p #{directory_path}`
  end

  def fetch_files_from_github
    body = HTTP.get(files_url).to_s
    JSON.parse(body).each do |file|
      @files << PullRequestFile.new(file, self)
    end
  end

  def delete_previously_generated_comments
    fetch_pull_request_comments
    @pull_request_comments.each do |pull_request_comment|
      if pull_request_comment.reek_comment?
        HTTP.delete("#{pull_request_comment.url}#{access_token_as_param}")
      end
    end
  end

  def fetch_pull_request_comments
    comments_json = HTTP.get(comments_url(access_token: false))
    JSON.parse(comments_json).each do |comment|
      @pull_request_comments << PullRequestComment.new(comment)
    end
  end

  def run_reek
    @files.each(&:run_reek)
  end

  def send_results_to_github
    @files.each(&:post_file_output_to_github)
  end

  def clean_up
    `rm -rf #{directory_path}`
  end

  def create_stored_pull_request
    PullRequest.create(url: pull_request_url, reek_smells: reek_smells_count)
  end

  def reek_smells_count
    @files.sum(&:reek_smells_count)
  end
end
