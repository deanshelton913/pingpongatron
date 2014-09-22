class Player < ActiveRecord::Base
  def initialize(name)
    @name = name
  end
end
