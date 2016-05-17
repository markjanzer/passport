require 'sinatra'
require 'json'

class PiranhaViewServer
  attr_reader :boats, :timeslots

  def initialize
    @boats = {}
    @timeslots = {}
    @@boat_count = 0
    @@timeslot_count = 0
  end

end