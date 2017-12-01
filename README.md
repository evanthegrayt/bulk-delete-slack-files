# delete-multiple-slack-files
Ruby script that utilizes the Slack API to delete multiple files on Slack

### Getting Started
- Get your token from [Slack](https://api.slack.com/custom-integrations/legacy-tokens)
- Set your name and token in `config/user_info.yml`
- Make sure ruby version 2.1.1 is installed
- Install the Slack API gem (`gem install slack-api`)

### Usage
- Add the repository's bin to your `PATH`, or better yet, link it.
- Run this with `-h` for help, `-t` for test, or no opts to actually delete
    files.

