# delete-multiple-slack-files
Ruby script that utilizes the Slack API to delete multiple files on Slack

### Installation
- Clone the repository
`git clone https://github.com/evanthegrayt/delete-multiple-slack-files.git`
- Install the `slack-api` gem, version `1.6.0`
  - If you have [bundler](https://bundler.io/) installed, run `bundle install`
  from the root directory of the repo.
  - If you don't have `bundler` installed, run `gem install slack-api -v 1.6.0`
- Get your [Legacy Token from
Slack](https://api.slack.com/custom-integrations/legacy-tokens)
- If you don't want to manually pass your name and token every time, you can
export `SLACK_NAME` and `SLACK_TOKEN` as environmental variables. You can type
them in from the command line, or add them to something like your `~/.bashrc` or
`~/.zshrc` file and `source`-ing the file.
```bash
export SLACK_NAME="REAL NAME" # Make sure to use "Real Name" from Slack
export SLACK_TOKEN="SLACK TOKEN"
```

### Usage
- You can modify the file to be executable and put in your path, or call it
explicitly with `ruby delete_slack_files.rb`
- If you don't want to export your name and token as environmental variables,
pass `-T [TOKEN] -N [NAME]` at runtime.
- Run this with `-t` for test, or no arguments to actually delete files.
- Run with `-h` to see all available options

