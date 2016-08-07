module AdaBoost

  class Resampler

    def initialize y_index
      @y_index = y_index
    end
    
    def over_sample samples
      distribution = distribution samples
      y0 = distribution.negative
      y1 = distribution.positive
      majority = y0 < y1 ? 1.0 : -1.0
      difference = (y0 - y1).abs
      samples.each do |sample|
        if difference <= 0
          break
        end
        if sample[@y_index] != majority
          samples << sample
          difference -= 1
        end
      end
    end

    private

    def distribution instances
      analyzer = FeaturesAnalyzer.new @y_index
      analyzer.analyze(instances).distribution
    end
  end
end
