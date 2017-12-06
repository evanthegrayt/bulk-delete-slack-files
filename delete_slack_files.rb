#!/usr/bin/env ruby

require 'yaml'
require 'optparse'
require 'slack'

class SlackFileDeleter
  def initialize(name, token, opts = {})
    @name   = name
    @client = Slack::Client.new(token: token)
    @opts   = opts

    @opts[:test]  ||= false
    @opts[:count] ||= 1000
    @opts[:days]  ||= 30
  end

  def delete_all_old_files
    del_count = 0
    file_list.each do |file|
      if meets_requirements?(file)
        puts "#{delete_word}: [#{file['name']}]"
        delete_file(file) unless @opts[:test]
        del_count += 1
      end
    end
    puts "\n#{del_count} Files #{delete_word}."
  end

  private

  def delete_file(file)
    @client.files_delete(file: file['id'])
  end

  def file_list
    @client.files_list(count: @opts[:count])['files']
  end

  def meets_requirements?(file)
    file['created'] < date.to_i && file['user'] == uid
  end

  def uid
    @uid ||= @client.users_list['members'].select do |m|
      m['profile']['real_name'] == @name
    end.first['id']
  end

  def delete_word
    @opts[:test] ? 'To Delete' : 'Deleted'
  end

  def date
    Time.now - @opts[:days] * 24 * 60 * 60
  end

end

if $PROGRAM_NAME == __FILE__
  def usage
    <<-EOF.gsub(/^\s*>/, '')
    >You need to pass your name and token,\n
    >or set them as environmental varibales!\n
    >    export SLACK_NAME='YOUR_SLACK_NAME'\n
    >    export SLACK_TOKEN='YOUR_SLACK_TOKEN'
    EOF
  end
  opts = {}

  OptionParser.new do |o|
    o.on('-l', '--[no-]list',
         "List files to delete; don't delete") { |v| opts[:test] = v }
    o.on('-t', '--[no-]test', "Same as '-l'") { |v| opts[:test] = v }
    o.on('-T', '--token=TOKEN', "Manually pass TOKEN") { |v| opts[:token] = v }
    o.on('-N', '--name=NAME', "Manually pass NAME") { |v| opts[:name] = v }
    o.on('-c', '--count=COUNT', Integer,
         "Number of files to consider deleting",
         "Default is 1000") { |v| opts[:count] = v }
    o.on('-d', '--days-ago=DAYS', Integer,
         "Number of days ago to consider deleting",
         "Default is 30") { |v| opts[:days] = v }
  end.parse!

  name  = opts[:name]  || ENV['SLACK_NAME']
  token = opts[:token] || ENV['SLACK_TOKEN']

  [name, token].each do |e|
    if e.nil? || e.empty?
      abort(usage)
    end
  end

  slack_deleter = SlackFileDeleter.new(name, token, opts)

  slack_deleter.delete_all_old_files

end

