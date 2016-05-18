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

  def get_timeslots_by_date(date)
    timeslots_of_date = @timeslots.select do |timeslot|
      timeslot.get_date_as_string == date
    end
    timeslots_of_date
  end

  def assign_boat_to_timeslot(timeslot_id, boat_id)
    chosen_timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    boat = @boats.select { |boat| boat.id.to_s == boat_id }[0]
    # Get all timeslots of that date
    timeslots_of_same_date = get_timeslots_by_date(chosen_timeslot.get_date_as_string)
    # Get all timeslots of that date with that boat
    timeslots_with_same_date_and_boat = timeslots_of_same_date.select do |timeslot|
      this_boat = timeslot.boats.select { |boat| boat.id.to_s == boat_id}
      this_boat.length > 0
    end
    # Compare each of these timeslots to see if they have any overlapping time
    overlap = timeslots_with_same_date_and_boat.any? do |timeslot|
      check_timeslots_for_overlap(chosen_timeslot, timeslot)
    end
    p "OVERLAP"
    p overlap
    if overlap
      # Would raise error here
      return "false"
    else
      chosen_timeslot.add_boat(boat)
    end
  end

  def create_booking(timeslot_id, size)
    timeslot = @timeslots.select { |timeslot| timeslot.id.to_s == timeslot_id }[0]
    # Return false if timeslot does not exist
    return "false" if !timeslot
    # Find index of smallest capacity that can hold the group.
    ideal_boat = timeslot.boats.find { |boat| boat.availability >= size.to_i }
    if ideal_boat
      # Add booking and subtract capacity
      ideal_boat.availability -= size.to_i
      timeslot.customer_count += size.to_i
      timeslot.update_availability
    else
      # Would raise error here
      return "false"
    end
  end

  def get_collection_as_hashes(collection)
    array_of_hashes = collection.map { |item| item.to_hash }
    array_of_hashes
  end

  private

  # Not sure where I should put this method
  def check_timeslots_for_overlap(timeslot1, timeslot2)
    chosen_time_does_not_end_soon_enough = ((timeslot1.beginning_time < timeslot2.beginning_time) && (timeslot1.end_time > timeslot2.beginning_time))
    they_begin_at_the_same_time = (timeslot1.beginning_time == timeslot2.beginning_time)
    they_end_at_the_same_time = (timeslot1.end_time == timeslot2.end_time)
    chosen_time_does_not_begin_late_enough = ((timeslot1.beginning_time > timeslot2.beginning_time) && (timeslot1.beginning_time < timeslot2.end_time))
    # If any of these are true, then the timeslots are overlapping and the assignment is invalid
    return (chosen_time_does_not_end_soon_enough || they_begin_at_the_same_time || they_end_at_the_same_time || chosen_time_does_not_begin_late_enough)
    end
end
