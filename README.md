# Bulk Delete Slack Files
Ruby script that utilizes the Slack API to bulk-delete files on Slack.
Useful for people who use the free version of Slack and have a storage size
limit, which requires you to bulk-delete files (which they conveniently don't
have an easy way to do...)

By default, the program will delete files older than 30 days, or the oldest
1,000 files, whichever limit is hit first. These are configurable through
options.

## Installation
- Clone the repository
`git clone https://github.com/evanthegrayt/bulk-delete-slack-files.git`
- If using Rake (`gem install rake`) run `rake` from the base directory;
otherwise, run
`ln -s $PWD/bin/delete_slack_files /usr/local/bin/delete_slack_files`
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

## Usage
- If you installed via `rake`, or manually linked to a directory in your
`$PATH`, you should be able to call the executable.
```sh
delete_slack_files -t
```
- Run with `-t` to test, or no arguments to actually delete files.
- If you don't want to export your name and token as environmental variables,
pass `-T [TOKEN] -N [NAME]` at runtime.
- Run with `-h` to see all available options

## Reporting Bugs
If you find any bugs, or anything that could be improved, please [submit an
issue](https://github.com/evanthegrayt/bulk-delete-slack-files/issues/new).
My company no longer uses Slack, so this script probably won't be updated much
or given new features unless issues are submitted. If people make issues, I will
update the code.

## Self Promotion
I do these projects for fun, and I enjoy knowing that they're helpful to people.
Consider starring [the
repository](https://github.com/evanthegrayt/bulk-delete-slack-files) if you like
it! If you love it, follow me [on github](https://github.com/evanthegrayt)!
