require 'rubygems'
require 'logger'

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

logfile = open 'irc.log', 'a'
logfile.sync = true
logger = Logger.new logfile


configure do |c|
  c.nick = opts[:nick]
  c.server = 'irc.freenode.net'
end

on :connect do
  join *opts[:channels]
  logger.info "#" * 20
  logger.info "Connected!"
end

on :channel, /\#(\d+)/ do |ticket_id|
  uri = "http://code.fabfile.org/issues/show/#{ticket_id}"
  subject = ticket_subject uri
  reply = "Ticket \##{ticket_id}: #{subject} (#{uri})"
  msg(channel, reply) unless subject.nil?
end

on :channel do
  logger.debug message.inspect
end
