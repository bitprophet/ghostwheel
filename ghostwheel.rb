require 'rubygems'

require 'isaac'


configure do |c|
  c.nick = 'Ghostwheel'
  c.server = 'irc.freenode.net'
end

on :connect do
  join '#fabfile'
end

on :channel, /\#(\d+)/ do |ticket_id|
  uri = "http://code.fabfile.org/issues/show/#{ticket_id}"
  subject = Redmine::test uri
  msg(channel, "Ticket \##{ticket_id}: #{subject} (#{uri})") if subject
end
