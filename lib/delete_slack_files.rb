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

    @logger = Logger.new(File.join(
      File.dirname(File.realpath(__FILE__)), '..', 'log', 'slack.log')).freeze

    @opts[:test]  ||= false
    @opts[:count] ||= 1000
    @opts[:days]  ||= 30

    @delete_word = @opts[:test] ? 'To Delete' : 'Deleted'
  end

  def delete_all_old_files
    file_list.each do |file|
      next unless meets_requirements?(file)
      log_it("#{delete_word}: [#{file['name']}] " \
             "(#{(file['size'].to_f / MB).round(4)} MB)")
      @delete_fsize += file['size']
      delete_file(file) unless @opts[:test]
      @delete_count += 1
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
    return @uid if @uid
    uid = @client.users_list['members'].select do |m|
      m['profile']['real_name'] == @name
    end
    raise SlackCredentialError, INVALID_CREDENTIALS_MSG if uid.empty?
    @uid = uid.first['id']
  end

  def date
    Time.now - @opts[:days] * 24 * 60 * 60
  end

end

