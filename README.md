# delete-multiple-slack-files
Ruby script that utilizes the Slack API to delete multiple files on Slack

### Getting Started
- Clone the repository
`git clone https://github.com/evanthegrayt/delete-multiple-slack-files.git`
- Install the `slack-api` gem, version `1.6.0`
  - If you have [bundler](https://bundler.io/) installed, run `bundle install`
  from the root directory of the repo.
  - If you don't have `bundler` installed, run `gem install slack-api -v 1.6.0`
- Get your [Legacy Token from
Slack](https://api.slack.com/custom-integrations/legacy-tokens)
- If you don't want to manually pass your name and token every time, you can
    export `SLACK_NAME` and `SLACK_TOKEN` as environmental variables
- The name to use is your Slack "Real Name"

### Usage
- You can modify the file to be executable and put in your path, or call it
    explicitly with `ruby delete_slack_files.rb`
- Run this with `-h` for help, `-t` for test, or no opts to actually delete
    files.
- Run with `-h` for all available options

