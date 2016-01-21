require 'rails_helper'

describe CheckPullRequest do
  let(:repo) { 'craigsheen/some_repo' }
  let(:number) { 1 }
  let(:checker) { CheckPullRequest.new(repo, number) }

  describe '.directory_path' do
    specify { expect(checker.directory_path).to eq "#{Rails.root}/tmp/#{repo}/#{number}" }
  end

  describe '.files_url' do
    specify { expect(checker.files_url).to eq "https://api.github.com/repos/#{repo}/pulls/#{number}/files" }
  end

  describe '.comments_url' do
    context 'with no arguements passed' do
      specify { expect(checker.comments_url).to eq "https://api.github.com/repos/#{repo}/pulls/#{number}/comments?access_token=#{KeyVault[:access_token]}" }
    end

    context 'with access_token set to false' do
      specify { expect(checker.comments_url(access_token: false)).to eq "https://api.github.com/repos/#{repo}/pulls/#{number}/comments" }
    end

    context 'with access_token set to true' do
      specify { expect(checker.comments_url(access_token: true)).to eq "https://api.github.com/repos/#{repo}/pulls/#{number}/comments?access_token=#{KeyVault[:access_token]}" }
    end

    context 'with id set to 2' do
      specify { expect(checker.comments_url(comment_id: 2)).to eq "https://api.github.com/repos/#{repo}/pulls/#{number}/comments/2?access_token=#{KeyVault[:access_token]}" }
    end
  end

  describe '.run' do
    let(:file_hash) do
      { "sha"=>"1f1d11010bcd1afb69f6aab2c0c0c722136e0157", "filename"=>"app/models/author.rb",
        "status"=>"added", "additions"=>21, "deletions"=>0, "changes"=>21,
        "blob_url"=>"https://github.com/craigsheen/test-repo/blob/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
        "raw_url"=>"https://github.com/craigsheen/test-repo/raw/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
        "contents_url"=>"https://api.github.com/repos/craigsheen/test-repo/contents/app/models/author.rb?ref=3416a3ccace9a27b8f868be35dd8260ec17de569",
        "patch"=>"@@ -0,0 +1,21 @@\n+class Author < ActiveRecord::Base\n+  has_many :books" }
    end
    let(:files) do
      [PullRequestFile.new(file_hash, checker)]
    end

    before do
      expect(HTTP).to receive(:get).with("https://api.github.com/repos/#{repo}/pulls/#{number}/files").and_return(JSON.dump([file_hash]))
      expect(PullRequestFile).to receive(:new).with(file_hash, checker).and_return nil
      checker.stub(:delete_previously_generated_comments)
      checker.stub(:send_results_to_github)
      checker.stub(:run_reek)
    end

    it 'should have cleaned up the files' do
      checker.run
      File.directory?("#{Rails.root}/tmp/#{repo}/#{number}").should be false
    end
  end

  describe '.build_directory_for_temp_files' do
    it 'should create needed directory tree' do
      checker.send(:build_directory_for_temp_files)
      expect(File.directory?("#{Rails.root}/tmp/#{repo}")).to eq true
      expect(File.directory?("#{Rails.root}/tmp/#{repo}/#{number}")).to eq true
    end
  end
end
