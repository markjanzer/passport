require 'date'

class Timeslot
  # added extra readers for RSpec
  attr_reader :id, :beginning_time, :end_time, :customer_count, :start_time, :duration
  attr_accessor :boats, :customer_count, :availability, :customer_count
  def initialize(id, start_time, duration)
    @id = id
    @start_time = start_time.to_i
    @duration = duration.to_i

    @availability = 0
    @customer_count = 0
    @boats = []

    @beginning_time = Time.at(@start_time)
    @end_time = Time.at(@start_time) + 60*@duration
  end

  def get_date_as_string
    Time.at(@start_time).to_datetime.strftime("%Y-%m-%d")
  end

  def add_boat(boat)
    @boats << boat
    update_availability
  end

  def update_availability
    sort_boats
    @availability = @boats[-1].availability
  end

  # Sorts boats by available spaces, returns the largest availability
  def sort_boats
    @boats.sort! { |a, b| a.availability <=> b.availability }
  end

  def boat_ids
    boat_ids = @boats.map { |boat| boat.id }
    boat_ids
  end

  def to_hash
    {
      id: @id,
      start_time: @start_time,
      duration: @duration,
      availability: @availability,
      customer_count: @customer_count,
      boats: boat_ids
    }
  end

end
