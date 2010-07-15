require 'nokogiri'
require 'open-uri'


module Redmine
  def test_ticket_uri(uri)
    begin
      doc = Nokogiri::HTML(open(uri))
    rescue OpenURI::HTTPError
      nil 
    else
      header = doc.css('div.issue h3')
      header[0].content unless header.empty?
    end
  end
end
