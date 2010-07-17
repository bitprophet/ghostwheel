require 'rubygems'

require 'isaac'
require 'trollop'

require 'lib/redmine'


#
# Option parsing
#

opts = Trollop::options do
  opt :channels,
    "Comma-separated list of channels to join (#s optional)",
    :default => "fabfile"
  opt :nick,
    "Bot nickname",
    :default => 'Ghostwheel'
end

opts[:channels] = opts[:channels].split(",").map {|x|
  (x =~ /^#/) ? x : "\##{x}"
}


#
# Bot configuration
#

include Redmine

configure do |c|
  c.nick = opts[:nick]
  c.server = 'irc.freenode.net'
end

on :connect do
  join *opts[:channels]
end

on :channel, /\#(\d+)/ do |ticket_id|
  uri = "http://code.fabfile.org/issues/show/#{ticket_id}"
  subject = ticket_subject uri
  reply = "Ticket \##{ticket_id}: #{subject} (#{uri})"
  msg(channel, reply) unless subject.nil?
end
