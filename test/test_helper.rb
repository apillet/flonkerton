require 'protest'
require 'rr'
require File.dirname(__FILE__) + '/../lib/flonkerton'

class Protest::TestCase
  include RR::Adapters::TestUnit
end

Protest.report_with(:documentation)