require 'nokogiri'
require 'open-uri'


module Redmine
  def ticket_subject(uri)
    begin
      doc = Nokogiri::HTML(open(uri))
    rescue OpenURI::HTTPError
      nil # Just return nil if ticket URL doesn't exist
    else
      header = doc.css('div.issue h3')
      header[0].content unless header.empty?
    end
  end
end
