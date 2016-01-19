class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.debug "**\n\n\n\n\n#{params['action']}\n\n\n\n\n\n\n**"
    # if params["action"] == "opened"
      repo = params["repository"]["name"]
      id = params["number"]
      checker = CheckPullRequest.new(repo, id)
      Rails.logger.debug "**\n\n\n#{checker}\n\n\n**"
      checker.run
    # end
    render json: {}, status: 200
  end
end
