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

  def assign_boat_to_timeslot(timeslot_id, boat_id)
    timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    boat = @boats.select { |boat| boat.id.to_s == boat_id }[0]
    timeslot.boats << boat
    timeslot.update_availability
  end

  def create_booking(timeslot_id, size)
    timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    timeslot.customer_count += size.to_i
    timeslot.update_availability
  end

  # Not sure where I should put this method
  def get_collection_as_hashes(collection)
    array_of_hashes = collection.map { |item| item.to_hash }
    array_of_hashes
  end
end