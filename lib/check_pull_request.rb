class CheckPullRequest
  attr_reader :files, :repo, :id, :reek_output

  def initialize(repo, id)
    @repo = repo
    @id = id
    @files = []
    @reek_output = []
  end

  def run
    build_directory_for_temp_files
    fetch_files_from_github
    run_reek
    send_results_to_github
    clean_up
  end

  def directory_path
    "#{Rails.root.to_s}/tmp/#{repo}/#{id}"
  end

  def files_url
    "https://api.github.com/repos/#{repo}/pulls/#{id}/files"
  end

  def comments_url
    "https://api.github.com/repos/#{repo}/pulls/#{id}/comments?access_token=#{KeyVault[:access_token]}"
  end

  private
  attr_writer :files, :reek_output

  def build_directory_for_temp_files
    `mkdir -p #{directory_path}`
  end

  def fetch_files_from_github
    body = HTTP.get(files_url).to_s
    JSON.parse(body).each do |file|
      @files << PullRequestFile.new(file, self)
    end
  end

  def run_reek
    @files.each do |file|
      file.run_reek
    end
  end

  def send_results_to_github
    @files.each do |file|
      file.post_file_output_to_github
    end
  end

  def clean_up
    `rm -rf #{directory_path}`
  end
end
