require 'rails_helper'

describe PullRequestFile do
  let(:file_hash) do
    { "sha"=>"1f1d11010bcd1afb69f6aab2c0c0c722136e0157", "filename"=>"app/models/author.rb",
      "status"=>"added", "additions"=>21, "deletions"=>0, "changes"=>21,
      "blob_url"=>"https://github.com/craigsheen/test-repo/blob/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
      "raw_url"=>"https://github.com/craigsheen/test-repo/raw/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
      "contents_url"=>"https://api.github.com/repos/craigsheen/test-repo/contents/app/models/author.rb?ref=3416a3ccace9a27b8f868be35dd8260ec17de569",
      "patch"=>"@@ -0,0 +1,21 @@\n+class Author < ActiveRecord::Base\n+  has_many :books" }
  end
  let(:contents_hash) do
    { "name"=>"author.rb", "path"=>"app/models/author.rb", "sha"=>"1f1d11010bcd1afb69f6aab2c0c0c722136e0157", "size"=>269,
      "url"=>"https://api.github.com/repos/craigsheen/test-repo/contents/app/models/author.rb?ref=3416a3ccace9a27b8f868be35dd8260ec17de569",
      "html_url"=>"https://github.com/craigsheen/test-repo/blob/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
      "git_url"=>"https://api.github.com/repos/craigsheen/test-repo/git/blobs/1f1d11010bcd1afb69f6aab2c0c0c722136e0157",
      "download_url"=>"https://raw.githubusercontent.com/craigsheen/test-repo/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb",
      "type"=>"file", "content"=>"Y2xhc3MgQXV0aG9yIDwgQWN0aXZlUmVjb3JkOjpCYXNlCiAgaGFzX21hbnkg\nOmJvb2tzCgogIGRlZiBhCiAgICBpZiB0cnVlCiAgICAgIGlmIHRydWUKICAg\nICAgICBpZiB0cnVlCiAgICAgICAgICBpZiB0cnVlCiAgICAgICAgICAgIGlm\nIHRydWUKICAgICAgICAgICAgICAnYmxhaCcKICAgICAgICAgICAgZW5kCiAg\nICAgICAgICBlbmQKICAgICAgICBlbmQKICAgICAgZW5kCiAgICBlbmQKICBl\nbmQKCiAgZGVmIGZ1bGxfbmFtZQogICAgJ2ZvbyBiYXInCiAgZW5kCmVuZAo=\n",
      "encoding"=>"base64", "_links"=>{"self"=>"https://api.github.com/repos/craigsheen/test-repo/contents/app/models/author.rb?ref=3416a3ccace9a27b8f868be35dd8260ec17de569",
      "git"=>"https://api.github.com/repos/craigsheen/test-repo/git/blobs/1f1d11010bcd1afb69f6aab2c0c0c722136e0157",
      "html"=>"https://github.com/craigsheen/test-repo/blob/3416a3ccace9a27b8f868be35dd8260ec17de569/app/models/author.rb"} }
  end
  let(:expected_reek_output) do
    [{"context"=>"Author", "lines"=>[1], "message"=>"has no descriptive comment", "smell_category"=>"IrresponsibleModule",
      "smell_type"=>"IrresponsibleModule", "source"=>"/Users/craigsheen/development/other/olfaction/tmp/craigsheen/test-repo/5/author.rb20160120-23525-1ceu0qm.rb",
      "name"=>"Author", "wiki_link"=>"https://github.com/troessner/reek/blob/master/docs/Irresponsible-Module.md"},
      {"context"=>"Author", "lines"=>[9, 8, 7, 6, 5], "message"=>"tests true at least 5 times", "smell_category"=>"SimulatedPolymorphism",
      "smell_type"=>"RepeatedConditional", "source"=>"/Users/craigsheen/development/other/olfaction/tmp/craigsheen/test-repo/5/author.rb20160120-23525-1ceu0qm.rb",
      "name"=>"true", "count"=>5, "wiki_link"=>"https://github.com/troessner/reek/blob/master/docs/Repeated-Conditional.md"},
      {"context"=>"Author#a", "lines"=>[4], "message"=>"has the name 'a'", "smell_category"=>"UncommunicativeName", "smell_type"=>"UncommunicativeMethodName",
      "source"=>"/Users/craigsheen/development/other/olfaction/tmp/craigsheen/test-repo/5/author.rb20160120-23525-1ceu0qm.rb",
      "name"=>"a", "wiki_link"=>"https://github.com/troessner/reek/blob/master/docs/Uncommunicative-Method-Name.md"}]
  end
  let(:repo) { 'craigsheen/some_repo' }
  let(:number) { 1 }
  let(:checker) { CheckPullRequest.new(repo, number) }
  let(:file) { PullRequestFile.new(file_hash, checker) }

  before do
    PullRequestFile.any_instance.instance_eval("@contents_hash = #{contents_hash}")
  end

  describe 'attributes set on initialize' do
    specify { expect(file.path).to eq file_hash['filename'] }
    specify { expect(file.sha).to eq contents_hash['url'].split("?ref=")[1] }
    specify { expect(file.file_name).to eq contents_hash['name'] }
    specify { expect(file.raw_url).to eq contents_hash['download_url'] }
  end

  # TODO: Test tempfile creation

  describe '.run_reek' do
    it 'should set reek ouput' do
      expect(file).to receive(:reek_output).and_return expected_reek_output
      file.run_reek
      expect(file.reek_output).to eq expected_reek_output
    end
  end
end
