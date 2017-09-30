class Card
  include Comparable

  BIG_ACE = 11
  VALUES = {
    "2"  =>  2,
    "3"  =>  3,
    "4"  =>  4,
    "5"  =>  5,
    "6"  =>  6,
    "7"  =>  7,
    "8"  =>  8,
    "9"  =>  9,
    "10" =>  10,
    "J"  =>  10,
    "Q"  =>  10,
    "K"  =>  10,
    "A"  =>  { small: 1, big: 11 }
  }

  attr_reader :suit, :face

  def initialize(face, suit)
    @face = face.to_s
    @suit = suit
  end

  def <=>(other)
    first_val  = (face == "A") ? value[:big] : value
    second_val = (other.face == "A") ? other.value[:big] : other.value
    if first_val == second_val
      0
    elsif first_val < second_val
      -1
    elsif first_val > second_val
      1
    end
  end

  def to_s
    "#{face}#{suit}"
  end

  def value
    VALUES[face]
  end

  def value_for(current_sum)
    if face == "A"
      (current_sum < BIG_ACE) ? value[:big] : value[:small]
    else
      value
    end
  end
end

