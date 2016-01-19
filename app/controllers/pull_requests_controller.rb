class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if params["action"] == "opened"
      repo = params["repository"]["name"]
      id = params["number"]
      checker = CheckPullRequest.new(repo, id)
      Rails.logger.debug checker
      checker.run
    end
  end
end
