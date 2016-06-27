class PullRequestFile
  attr_reader :file_hash, :contents_hash, :sha, :path, :file_name, :raw_url,
              :check_pull_request, :contents, :tempfile, :reek_output

  def initialize(file_hash, check_pull_request)
    @file_hash = file_hash
    @check_pull_request = check_pull_request
    init_file
    build_temp_file
  end

  def run_reek
    @reek_output = JSON.parse(`reek #{tempfile.path} --format json`)
  end

  def post_file_output_to_github
    args = { body: comment_body, commit_id: sha, path: path, position: 1 }
    url = check_pull_request.comments_url
    HTTP.post(url, json: args)
  end

  private

  attr_writer :sha, :file_name, :raw_url, :contents, :tempfile

  def init_file
    @contents_hash = get_pull_request_file_contents_hash
    @path = file_hash['filename']
    @sha = contents_hash['url'].split('?ref=')[1] # This is awful but it seems the sha field is not the sha of the commit.
    @file_name = contents_hash['name']
    @raw_url = contents_hash['download_url']
    @contents = get_raw_content
  end

  def get_pull_request_file_contents_hash
    JSON.parse(HTTP.get(file_hash['contents_url']).to_s)
  end

  def get_raw_content
    HTTP.get(raw_url).to_s
  end

  def build_temp_file
    @tempfile = Tempfile.new([file_name, '.rb'], check_pull_request.directory_path)
    @tempfile.binmode
    @tempfile.write contents
    @tempfile.rewind
  end

  def comment_body
    comment_body_text = []
    reek_output.each do |issue|
      comment_body_text << "[#{issue['smell_type']}](#{issue['wiki_link']}): #{issue['message']}\nLines: #{issue['lines']}"
    end
    comment_body_text.join("\n").prepend("## Reek Code Smells Found\n")
  end
end
