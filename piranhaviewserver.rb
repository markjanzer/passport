require 'sinatra'
require 'json'
require 'boat'
require 'timeslot'


class PiranhaViewServer
  attr_reader :boats, :timeslots

  def initialize
    @boats = []
    @timeslots = []
    @@new_boat_id = 0
    @@new_timeslot_id = 0
  end

  def new_boat(capacity, name)
    boat = Boat.new(@@new_boat_id, capactiy, name)
    @boats[boat.id] = boat
    @@new_boat_id += 1
    return boat
  end

  def new_timeslot(start_time, duration)
    timeslot = Timeslot.new(@@new_timeslot_id, start_time, duration)
    @timeslot[timeslot.id] = timeslot
    @@new_timeslot_id += 1
    return Timeslot
  end
end