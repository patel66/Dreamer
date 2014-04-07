require './lib/dreamer.rb'

DMR.db_name = 'DMR_test.db'

RSpec.configure do |config|
  config.before(:each) do
    DMR.instance_variable_set(:@__db_instance, nil)

    DMR.db.clear_all_records
  end
end
