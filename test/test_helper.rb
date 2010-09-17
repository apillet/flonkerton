require 'protest'
require 'override'
require File.dirname(__FILE__) + '/../lib/flonkerton'

include Override

Protest.report_with(:documentation)
