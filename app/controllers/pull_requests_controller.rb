class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if params["action"] == "created"
      repo = params["repository"]["full_name"]
      id = params["number"]
      checker = CheckPullRequest.new(repo, id)
      checker.run
    end
    render json: {}, status: 200
  end
end
