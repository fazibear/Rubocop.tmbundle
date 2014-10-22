#!/usr/bin/env ruby

require 'rubocop'

processed_source = RuboCop::ProcessedSource.from_file(ENV['TM_FILEPATH'])
team = RuboCop::Cop::Team.new(
  RuboCop::Cop::Cop.all, 
  RuboCop::ConfigStore.new.for(processed_source.path), 
  {}
)
offenses = team.inspect_file(processed_source)

args = [ "--clear-mark=error" ]

offenses.each do |offence|
  args << "--set-mark=error:\"#{offence.message}\""
  args << "--line=#{offence.line}" 
end

args << ENV['TM_FILEPATH'].inspect

`#{ENV['TM_MATE']} #{args.join(' ')}`
