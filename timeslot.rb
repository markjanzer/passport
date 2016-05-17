class Timeslot
  attr_reader :id
  def initialize(id, start_time, duration)
    @id = id
    @start_time = start_time
    @duration = duration

    @availability = 0
    @customer_count = 0
    @boats = {}
  end
end
