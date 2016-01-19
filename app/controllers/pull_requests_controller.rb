class PullRequestsController < ApplicationController
  def create
    Rails.logger.debug params
    if params[:action] == "opened"
      repo = params[:repository][:name]
      id = params[:number]
      CheckPullRequest.new(repo, id).run
    end
  end
end
