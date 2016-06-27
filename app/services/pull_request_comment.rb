class PullRequestComment
  attr_reader :id, :url, :user_login, :body

  def initialize(comment_hash)
    @id = comment_hash['id']
    @url = comment_hash['url']
    @user_login = comment_hash['user']['login']
    @body = comment_hash['body']
  end

  def reek_comment?
    body.starts_with?('## Reek Code Smells Found')
  end
end
