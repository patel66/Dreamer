require 'spec_helper'

module DMR
  describe 'CalculateCycles' do
    it "calculates the right number of cycles per night" do
      cycles1 = CalculateCycles.run(Time.new(2014,4,15,21), Time.new(2014,4,16,5))
      cycles2 = CalculateCycles.run(Time.new(2014,4,16,22,30), Time.new(2014,4,17,7,30))
      cycles3 = CalculateCycles.run(Time.new(2014,4,17,3), Time.new(2014,4,17,4,30))

      expect(cycles1).to eq(5)
      expect(cycles2).to eq(5)
      expect(cycles3).to eq(0)
    end

  end
end
