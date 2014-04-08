module DMR
  class CalculateCycles
    def self.run(start_time, end_time)
      sleep = end_time - start_time
      if sleep < (2 * 60 * 60)
        return 0
      else
        sleep = sleep - (2 * 60 * 60)
        return ((sleep/(90 * 60)).floor + 1)
      end
    end
  end
end
