require 'sinatra'
require 'rmeetup'
require 'awesome_print'

get '/' do
  @next_meeting = UpcomingMeeting.new
  haml :index
end

class UpcomingMeeting
  extend Forwardable
  attr_reader :next_meeting

  delegate [:name, :description, :event_url] => :next_meeting

  def initialize
    RMeetup::Client.api_key = ENV['MEETUP_KEY']
    @next_meeting = RMeetup::Client.fetch(:events,{group_urlname: "winnipegrb"}).first
  end

  def present?
    ! @next_meeting.nil?
  end

  def venue
    "%s<br>%s" % [ vinfo('name'), vinfo('address_1') ]
  end

  def time
    @next_meeting.time.strftime "%a, %b %d, %Y"
  end

  private

  def vinfo(element)
    @next_meeting.venue[element]
  end
end
