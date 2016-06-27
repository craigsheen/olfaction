class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    repo = params["repository"]["full_name"]
    id = params["number"]
    checker = CheckPullRequest.new(repo, id)
    checker.execute
    render json: {}, status: 200
  end
end
