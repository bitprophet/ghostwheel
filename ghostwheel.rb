require 'rubygems'

require 'isaac'

require 'lib/redmine'

include Redmine

configure do |c|
  c.nick = 'Ghostwheel'
  c.server = 'irc.freenode.net'
end

on :connect do
  join '#fabfile'
end

on :channel, /\#(\d+)/ do |ticket_id|
  uri = "http://code.fabfile.org/issues/show/#{ticket_id}"
  subject = ticket_subject uri
  reply = "Ticket \##{ticket_id}: #{subject} (#{uri})"
  msg(channel, reply) unless subject.nil?
end
