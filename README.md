# Olfaction

Automatically detect code smells in your pull requests.

## How to

1. Fork this repo.

2. Deploy to wherever you want.

3. Get a GitHub [access_token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/).

4. Set your GitHub `access_token` to `ENV['access_token']`.

5. Set a [webhook](https://developer.github.com/webhooks/) on which ever repo(s) you want to detect code smells on. You will need to select `Let me select individual events.` and then `Pull Request` from the options. Set the Payload URL to be `<MY_URL>/pull_requests`.

6. When a new pull request is created, GitHub will send the details to your forked application, the application will then run reek on the changed files and comment directly on your pull request with any code smells. [See example here](https://github.com/craigsheen/test-repo/pull/5)

### Thanks

Obviously this heavily relies on [reek](https://github.com/troessner/reek)

### TODO

* Integrate more than `reek`?
