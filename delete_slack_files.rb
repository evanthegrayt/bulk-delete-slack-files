#!/usr/bin/env ruby

require 'optparse'
require 'slack'
require 'logger'

class SlackFileDeleter

  SlackCredentialError = Class.new(StandardError)

  INVALID_CREDENTIALS_MSG = 'Incorrect Token or User Name!'.freeze
  MB = 1_000_000

  attr_reader :delete_count, :delete_word

  def initialize(name, token, opts = {})
    @name         = name
    @client       = Slack::Client.new(token: token)
    @opts         = opts
    @delete_count = 0
    @delete_fsize = 0

    @logger = Logger.new(File.join(__dir__, 'log', 'slack.log'), 0, 1048576)

    @opts[:test]  ||= false
    @opts[:count] ||= 1000
    @opts[:days]  ||= 30

    @delete_word = @opts[:test] ? 'To Delete' : 'Deleted'
  end

  def delete_all_old_files
    file_list.each do |file|
      if meets_requirements?(file)
        log_it("#{delete_word}: [#{file['name']}] " \
               "(#{(file['size'].to_f / MB).round(4)} MB)")
        @delete_fsize += file['size']
        delete_file(file) unless @opts[:test]
        @delete_count += 1
      end
    end
  end

  def log_it(msg, level = :info)
    @logger.send(level, msg)
    puts "#{Time.now} #{level.upcase}: #{msg}"
  end

  def fsize
    (@delete_fsize.to_f / MB).round(4)
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
    @uid ||=
      begin
        uid = @client.users_list['members'].select do |m|
          m['profile']['real_name'] == @name
        end
        raise SlackCredentialError, INVALID_CREDENTIALS_MSG if uid.empty?
        uid.first['id']
      end
  end

  def date
    Time.now - @opts[:days] * 24 * 60 * 60
  end

end

if $PROGRAM_NAME == __FILE__
  TOKEN_NAME_ERROR = <<-EOF.gsub(/^\s*>/, '')
    >You need to pass your name and token,
    >or set them as environmental varibales!
    >    export SLACK_NAME='YOUR_SLACK_NAME'
    >    export SLACK_TOKEN='YOUR_SLACK_TOKEN'
  EOF

  opts = {}

  OptionParser.new do |o|
    o.on('-l', '--[no-]list',
         "List files to delete; don't delete") { |v| opts[:test] = v }
    o.on('-t', '--[no-]test', "Same as '-l'") { |v| opts[:test] = v }
    o.on('-T', '--token=TOKEN', 'Manually pass TOKEN') { |v| opts[:token] = v }
    o.on('-N', '--name=NAME', 'Manually pass NAME') { |v| opts[:name] = v }
    o.on('-c', '--count=COUNT', Integer,
         'Number of files to consider deleting',
         'Default is 1000') { |v| opts[:count] = v }
    o.on('-d', '--days-ago=DAYS', Integer,
         'Number of days ago to consider deleting',
         'Default is 30') { |v| opts[:days] = v }
  end.parse!

  name  = opts[:name]  || ENV['SLACK_NAME']
  token = opts[:token] || ENV['SLACK_TOKEN']

  [name, token].each { |e| abort(TOKEN_NAME_ERROR) if e.nil? || e.empty? }

  slack_deleter = SlackFileDeleter.new(name, token, opts)

  slack_deleter.delete_all_old_files

  slack_deleter.log_it(
    "#{slack_deleter.delete_count} Files #{slack_deleter.delete_word} " \
    "- Total Space: #{slack_deleter.fsize} MB")

end

