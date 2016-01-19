class PullRequestsController < ApplicationController
  def create
    if params[:action] == "opened"
      repo = params[:repository][:name]
      id = params[:number]
      CheckPullRequest.new(repo, id).run
    end
  end
end
