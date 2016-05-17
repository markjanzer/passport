require 'sinatra'
require 'json'
require_relative 'boat'
require_relative 'timeslot'


class PiranhaViewServer
  attr_reader :boats, :timeslots

  def initialize
    @boats = []
    @timeslots = []
    @@new_boat_id = 0
    @@new_timeslot_id = 0
  end

  def new_boat(capacity, name)
    boat = Boat.new(@@new_boat_id, capacity, name)
    @boats << boat
    @@new_boat_id += 1
    return boat
  end

  def new_timeslot(start_time, duration)
    timeslot = Timeslot.new(@@new_timeslot_id, start_time, duration)
    @timeslots << timeslot
    @@new_timeslot_id += 1
    return timeslot
  end

  def get_collection_as_hashes(collection)
    array_of_hashes = collection.map { |item| item.to_hash }
    array_of_hashes
  end
end