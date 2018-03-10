$LOAD_PATH << 'test'
require 'minitest/spec'
module Rack
  class File
  end
end
describe Rack::File do
  it 'do something great' do
      assert_equal 200, 200
  end
end
