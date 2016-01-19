class PullRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    Rails.logger.debug params
    if params[:action] == "opened"
      repo = params[:repository][:name]
      id = params[:number]
      CheckPullRequest.new(repo, id).run
    end
  end
end
