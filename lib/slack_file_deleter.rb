#!/usr/bin/env ruby

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

