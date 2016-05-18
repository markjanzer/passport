class Boat
  attr_reader :id
  def initialize(id, name, capacity)
    @id = id
    @name = name
    @capacity = capacity
  end
end