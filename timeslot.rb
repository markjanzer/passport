require 'date'

class Timeslot
  attr_reader :id
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

  def to_hash
    {
      id: @id,
      start_time: @start_time,
      duration: @duration,
      availability: @availability,
      customer_count: @customer_count,
      boats: @boats
    }
  end

end
