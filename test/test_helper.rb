require 'protest'
require 'override'
require File.dirname(__FILE__) + '/../lib/flonkerton'

include Override

Protest.report_with(:documentation)

class Protest::TestCase
  def assert_nothing_raised
    begin
      yield
    rescue Exception => e
      assert false, "Exception raised: #{e.class}"
    end
  end
end