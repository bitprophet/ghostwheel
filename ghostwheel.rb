require 'rubygems'
require 'logger'

require 'isaac'

require 'lib/redmine'

include Redmine

logfile = open 'irc.log', 'a'
logfile.sync = true
logger = Logger.new logfile


configure do |c|
  c.nick = 'Ghostwheel'
  c.server = 'irc.freenode.net'
end

on :connect do
  join '#fabfile', '#fabric'
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
