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
  messages = {
    refactor: {},
    convention: {},
    warning: {},
    error: {},
    fatal: {}
  }
  offences.each do |offence|
    message = messages[offence.severity.name][offence.line] ||= []
    message << offence.message.gsub('`', "'").gsub(',', ' ')
  end
  messages
end

def command(messages)
  icons = {
    refactor:   "#{ENV['TM_BUNDLE_SUPPORT']}/evil.pdf".inspect,
    convention: "#{ENV['TM_BUNDLE_SUPPORT']}/confused.pdf".inspect,
    warning:    "#{ENV['TM_BUNDLE_SUPPORT']}/neutral.pdf".inspect,
    error:      "#{ENV['TM_BUNDLE_SUPPORT']}/sad.pdf".inspect,
    fatal:      "#{ENV['TM_BUNDLE_SUPPORT']}/shocked.pdf".inspect
  }
  args = []

  messages.each do |severity, messages|
    args << ["--clear-mark=#{icons[severity]}"]
    messages.each do |line, message|
      args << "--set-mark=#{icons[severity]}:#{message.join(' ').inspect}"
      args << "--line=#{line}"
    end
  end

  args << ENV['TM_FILEPATH'].inspect

  "#{ENV['TM_MATE']} #{args.join(' ')}"
end

cmd = command(messages(offences(ENV['TM_FILEPATH'])))

# log cmd
exec cmd
