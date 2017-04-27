#!/usr/bin/env ruby

require 'shellwords'
begin
  require 'rubocop'
rescue LoadError
  puts "Install rubocop!\ngem install rubocop"
  exit 1
end

def log(msg)
  require 'logger'
  logger = Logger.new('/tmp/rubocop_bundle.log')
  logger.info msg
end

def offences(file)
  processed_source = RuboCop::ProcessedSource.from_file(file, RUBY_VERSION[0..2].to_f)
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
    refactor:   "#{ENV['TM_BUNDLE_SUPPORT']}/evil Template.pdf".shellescape,
    convention: "#{ENV['TM_BUNDLE_SUPPORT']}/confused Template.pdf".shellescape,
    warning:    "#{ENV['TM_BUNDLE_SUPPORT']}/neutral Template.pdf".shellescape,
    error:      "#{ENV['TM_BUNDLE_SUPPORT']}/sad Template.pdf".shellescape,
    fatal:      "#{ENV['TM_BUNDLE_SUPPORT']}/shocked Template.pdf".shellescape
  }
  args = []

  messages.each do |severity, messages|
    args << ["--clear-mark=#{icons[severity]}"]
    messages.each do |line, message|
      args << "--set-mark=#{icons[severity]}:#{message.uniq.join(' ').inspect}"
      args << "--line=#{line}"
    end
  end

  args << ENV['TM_FILEPATH'].inspect

  "#{ENV['TM_MATE']} #{args.join(' ')}"
end

cmd = command(messages(offences(ENV['TM_FILEPATH'])))

# log cmd
exec cmd
