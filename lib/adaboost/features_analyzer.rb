module AdaBoost

    Analyze = Struct.new(:statistics, :distribution)
    Distribution = Struct.new(:negative, :positive)
    FeatureStatistic = Struct.new(:min, :max, :sum, :avg, :vrn, :std, :rng)
    VariableRelations = Struct.new(:x, :y, :cov, :cor)

  class FeaturesAnalyzer

    def initialize(y_index)
      @y_index = y_index
    end

    def analyze(samples)
      
      statistics = []
      distribution = Distribution.new(0, 0)
      number_of_samples = samples.size
      
      if number_of_samples < 1
        raise ArgumentError.new('At least one sample is needed to analyze.')
      end
      number_of_features = @y_index
      sample_size = samples[0].size
      if number_of_features < 1 or sample_size < 2 or sample_size <= @y_index
        raise ArgumentError.new('At least 1 feature is needed to analyze.')
      end
      0.upto(number_of_features - 1) do
        statistics << FeatureStatistic.new(Float::MAX, -Float::MAX, 0, 0, 0, 0)
      end
      samples.each do |sample|
        y = sample[@y_index]
        if y == -1
            distribution.negative += 1
        else
            distribution.positive += 1
        end
        0.upto(number_of_features - 1) do |i|
          statistic = statistics[i]
          feature_value = sample[i]
          if feature_value < statistic.min
            statistic.min = feature_value
          end
          if feature_value > statistic.max
            statistic.max = feature_value
          end
          statistic.sum += feature_value
        end
      end
      statistics.each do |statistic|
        statistic.avg = statistic.sum / number_of_samples.to_f
        statistic.rng = (statistic.max - statistic.min).abs
      end
      samples.each do |sample|
        statistics.each_with_index do |statistic, i|
          feature_value = sample[i]
          statistic.vrn += (statistic.avg - feature_value) ** 2
        end
      end
      statistics.each do |statistic|
        statistic.vrn /= (number_of_samples - 1).to_f
        statistic.std = Math.sqrt statistic.vrn
      end
      analyze = Analyze.new
      analyze.statistics = statistics
      analyze.distribution = distribution
      analyze
    end

    def relations(x, y, samples, statistics)
      sum = 0.0
      samples.each do |sample|
        x_value = sample[x].to_f
        y_value = sample[y].to_f
        sum += (x_value - statistics[x].avg) * (y_value - statistics[y].avg)
      end
      cov = sum / (samples.size - 1).to_f
      cor = cov / (statistics[x].std * statistics[y].std).to_f
      VariableRelations.new(x, y, cov, cor)
    end
  end
end
