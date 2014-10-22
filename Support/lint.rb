#!/usr/bin/env ruby

require 'rubocop'

def log(msg)
  require 'logger'
  logger = Logger.new('/tmp/rubocop_bundle.log')
  logger.info msg
end

def offences(file)
  processed_source = RuboCop::ProcessedSource.from_file(file)
  team = RuboCop::Cop::Team.new(
    RuboCop::Cop::Cop.all,
    RuboCop::ConfigStore.new.for(processed_source.path),
    {}
  )
  team.inspect_file(processed_source)
end

def messages(offences)
  messages = {}
  offences.each do |offence|
    (messages[offence.line] ||= []) << offence.message.gsub('`', "'").gsub(',', ' ')
  end
  messages
end

def command(messages)
  warrning_icon = "#{ENV['TM_BUNDLE_SUPPORT']}/warrning.pdf".inspect
  args = ["--clear-mark=#{warrning_icon}"]

  messages.each do |line, message|
    args << "--set-mark=#{warrning_icon}:#{message.join(' ').inspect}"
    args << "--line=#{line}"
  end

  args << ENV['TM_FILEPATH'].inspect

  "#{ENV['TM_MATE']} #{args.join(' ')}"
end

cmd = command(messages(offences(ENV['TM_FILEPATH'])))

# log cmd
exec cmd
