class Boat
  attr_reader :id, :capacity
  attr_accessor :availability
  def initialize(id, capacity, name)
    @id = id
    @capacity = capacity.to_i
    @name = name
    @availability = @capacity
  end

  def to_hash
    {
      id: @id,
      capacity: @capacity,
      name: @name
    }
  end
end