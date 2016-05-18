class Boat
  attr_reader :id, :capacity
  def initialize(id, capacity, name)
    @id = id
    @capacity = capacity.to_i
    @name = name
  end

  def to_hash
    {
      id: @id,
      capacity: @capacity,
      name: @name
    }
  end
end