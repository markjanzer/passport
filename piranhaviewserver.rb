require 'sinatra'
require 'json'
require_relative 'boat'
require_relative 'timeslot'


class PiranhaViewServer
  attr_accessor :timeslots, :boats

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
    chosen_timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    boat = @boats.select { |boat| boat.id.to_s == boat_id }[0]
    # Get all of the timeslots that have the boat
    timeslots_that_have_boat = @timeslots.select do |timeslot|
      this_boat = timeslot.boats.select { |boat| boat.id.to_s == boat_id}
      this_boat.length > 0
    end

    # Compare each of these timeslots to see if they have any overlapping time
    overlap = timeslots_that_have_boat.any do |timeslot|
      check_timeslots_for_overlap(chosen_timeslot, timeslot)
    end
    if overlap
      # Not sure how I would raise an error
      return "false"
    else
      timeslot.boats << boat
      timeslot.update_availability
    end
  end

  def create_booking(timeslot_id, size)
    timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    timeslot.customer_count += size.to_i
    timeslot.update_availability
  end

  private
  # Not sure where I should put this method
  def get_collection_as_hashes(collection)
    array_of_hashes = collection.map { |item| item.to_hash }
    array_of_hashes
  end

  def check_timeslots_for_overlap(timeslot1, timeslot2)
    chosen_time_does_not_end_soon_enough = ((timeslot1.beginning_time > timeslot2.beginning_time) && (timeslot1.end_time > timeslot2.beginning_time))
    they_begin_at_the_same_time = (timeslot1.beginning_time == timeslot2.beginning_time)
    they_end_at_the_same_time = (timeslot1.end_time == timeslot2.end_time)
    chosen_time_does_not_begin_late_enough = ((timeslot1.beginning_time > timeslot2.beginning_time) && (timeslot1.beginning_time < timeslot2.end_time))
    # If any of these are true, then the timeslots are overlapping and the assignment is invalid
    return (chosen_time_does_not_end_soon_enough || they_begin_at_the_same_time || they_end_at_the_same_time || chosen_time_does_not_begin_late_enough)
    end
  end

end