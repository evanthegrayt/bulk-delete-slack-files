# delete-multiple-slack-files
Ruby script that utilizes the Slack API to delete multiple files on Slack

### Getting Started
- Get your token from [Slack](https://api.slack.com/custom-integrations/legacy-tokens)
- If you don't want to manually pass your name and token every time, you can
    export `SLACK_NAME` and `SLACK_TOKEN` as environmental variables
- Make sure ruby version 2.1.1 is installed
- Install the Slack API gem (`gem install slack-api`)

### Usage
- You can modify the file to be executable and put in your path, or call it
    explicitly with `ruby delete_slack_files.rb`
- Run this with `-h` for help, `-t` for test, or no opts to actually delete
    files.

