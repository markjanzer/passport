require 'date'

class Timeslot
  attr_reader :id, :beginning_time, :end_time
  attr_accessor :boats, :customer_count, :availability, :customer_count, :availability_by_boat
  def initialize(id, start_time, duration)
    @id = id
    @start_time = start_time.to_i
    @duration = duration.to_i

    @availability = 0
    @availability_by_boat = []
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
    @availability_by_boat << boat.capacity
    sort_availability_by_boat
    update_availability
  end

  def update_availability
    @availability = @availability_by_boat.reduce(0) { |sum, boat_capacity| sum + boat_capacity }
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

  # Sort to optimize boat utility, have large groups in boats that fit their size
  def sort_availability_by_boat
    @availability_by_boat = @availability_by_boat.sort
  end

end
