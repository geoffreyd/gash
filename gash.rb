#!/usr/bin/env ruby -w
require "rubygems"
require "readline"
require "lib/actor"
# lets pull in the plugins
Dir.glob(File.join(File.dirname(__FILE__), 'plugins/*.rb')).each { |f| require f }

@actions = {}
Actor.children.each do |c|
  c.actions.each do |name, reg|
    # add a new entry into the action hash, with the name being the symbol
    # passed through as the key for the regex, this will also be used for the
    # name of the method called.
    # we also then store the method to be called in the array ... not sure if this
    # is a good idea or not ... well find out soon enough.
    @actions[name] = {:method => c.method(name), :reg => reg}
  end
end

loop do
  cmd = Readline.readline('> ', true)
  # find which app this matches to
  matched = {}
  @actions.each do |name, options|
    if cmd[options[:reg]] != nil
      matched[name] = {:match => $~}.merge options if cmd[options[:reg]]
    end
  end
  if matched.size == 0
    puts "No one has claimed your action, try re-wording it ..."
  elsif matched.size == 1 # we have 
    exe = matched.to_a[0]
    puts exe[0]
    exe[1][:method].call exe[1][:match].captures
  else
    puts "found multiple matches:"
    puts matched.join(", ")
  end
end