require 'date'

class Timeslot
  attr_reader :id
  attr_accessor :boats, :customer_count
  def initialize(id, start_time, duration)
    @id = id
    @start_time = start_time.to_i
    @duration = duration.to_i

    @availability = 0
    @customer_count = 0
    @boats = []
  end

  def get_date_as_string
    Time.at(@start_time).to_datetime.strftime("%Y-%m-%d")
  end

  def update_availability
    total_space = @boats.reduce(0) do |availability, boat|
      availability + boat.capacity
    end
    @availability = total_space - @customer_count
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
