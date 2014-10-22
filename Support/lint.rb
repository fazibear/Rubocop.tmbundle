#!/usr/bin/env ruby

require 'rubocop'

processed_source = RuboCop::ProcessedSource.from_file(ENV['TM_FILEPATH'])
team = RuboCop::Cop::Team.new(
  RuboCop::Cop::Cop.all,
  RuboCop::ConfigStore.new.for(processed_source.path),
  {}
)
offenses = team.inspect_file(processed_source)

messages = {}

offenses.each do |offence|
  (messages[offence.line] ||= []) << offence.message.gsub('`', "").gsub(',',' ')
end

args = ['--clear-mark=error']

messages.each do |line, messages|
  args << "--set-mark=error:\"#{messages.join(' ')}\""
  args << "--line=#{line}"
end

args << ENV['TM_FILEPATH'].inspect

`#{ENV['TM_MATE']} #{args.join(' ')}"`
