require 'lib/redmine'

describe Redmine do
  include Redmine


  before do
    @base_uri = 'http://code.fabfile.org/issues/show'
  end

  def parsed_via_css(value) 
    OpenURI.stub!(:open_http)
    Nokogiri.stub!(:HTML).and_return(mock('doc', :css => value))
  end


  describe "ticket_subject" do
    it "should return nil on HTTPError" do
      err = OpenURI::HTTPError.new '404', nil
      OpenURI.stub!(:open_http).and_raise(err)
      ticket_subject("#{@base_uri}/NaN").should be_nil
    end

    it "should return nil if HTML parsing didn't find an issue subject" do
      parsed_via_css([])
      ticket_subject('http://www.google.com').should be_nil
    end

    it "should return subject if one was found" do
      parsed_via_css([mock('subject', :content => "subject yay")])
      ticket_subject("#{@base_uri}/7").should_not be_nil
    end
  end
end
