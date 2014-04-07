require './lib/dreamer.rb'

RSpec.configure do |config|
  config.before(:each) do
    DMR.instance_variable_set(:@__db_instance, nil)
  end
end
