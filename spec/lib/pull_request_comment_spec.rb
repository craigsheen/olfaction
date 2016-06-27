require 'rails_helper'

describe PullRequestComment do
  let(:comment_hash) do
    {
      'id' => id, 'url' => url, 'body' => body,
      'user' => { 'login' => user_login }
    }
  end
  let(:id) { 1 }
  let(:url) { 'http://example.com/comment/1' }
  let(:body) { 'This PR looks great' }
  let(:user_login) { 'craigsheen' }
  let(:comment) { PullRequestComment.new(comment_hash) }

  describe 'attributes set on initialize' do
    specify { expect(comment.id).to eq id }
    specify { expect(comment.url).to eq url }
    specify { expect(comment.body).to eq body }
    specify { expect(comment.user_login).to eq user_login }
  end

  describe '.reek_comment?' do
    context 'not a comment from olfaction' do
      specify { expect(comment.reek_comment?).to eq false }
    end

    context 'comment from olfaction' do
      let(:body) { '## Reek Code Smells Found\n Some reek output will be here' }
      specify { expect(comment.reek_comment?).to eq true }
    end
  end
end
