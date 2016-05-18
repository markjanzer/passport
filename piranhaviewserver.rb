require 'sinatra'
require 'json'
require 'boat.rb'
require 'timeslot.rb'

class PiranhaViewServer
  attr_reader :boats, :timeslots

  def initialize
    @boats = {}
    @timeslots = {}
    @@new_boat_id = 0
    @@new_timeslot_id = 0
  end

  def new_boat(name, capacity)
    boat = Boat.new(@@new_boat_id, name, capacity)
    @boats[boat.id] = boat
    @@new_boat_id += 1
  end

  def new_timeslot(start_time, duration)
    timeslot = Timeslot.new(@@new_timeslot_id, start_time, duration)
    @timeslot[timeslot.id] = timeslot
    @@new_timeslot_id += 1
  end
end