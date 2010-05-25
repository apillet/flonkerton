# Ruby 1.8.6 compatibility
#
unless Array.new.respond_to?(:sample)
  class Array
    def sample
      self.sort_by{ Kernel.rand }.pop
    end
  end
end

class Range
  def rand
    self.to_a.sample
  end
end

module Gosu
  class Color
    def self.random red = (0..255), green = (0..255), blue = (0..255)
      color = Color.new(0xff000000)
      color.red = red.rand
      color.green = green.rand
      color.blue = blue.rand
      color
    end
  end
end
