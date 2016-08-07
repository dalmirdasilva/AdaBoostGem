module AdaBoost

  class WeakLearner

    def initialize y_index
      @y_index = y_index
      @analyzer = FeaturesAnalyzer.new y_index
      @classifiers_cache = []
    end

    def features_satistics samples
       @analyzer.analyze(samples).statistics
    end

    def generate_weak_classifier samples, weights
      number_of_samples = samples.size
      if number_of_samples < 1
        raise ArgumentError.new 'At least one sample is needed to generate.'
      end
      number_of_features = @y_index
      sample_size = samples[0].size
      if number_of_features < 1 or sample_size < 2 or sample_size <= @y_index
        raise ArgumentError.new 'At least 1 feature is needed to generate.'
      end
      classifiers = []
      if Config::USE_RANDOM_WEAK_CLASSIFIERS
        classifiers = generate_random_classifiers samples, number_of_features
      else
        classifiers = generate_all_possible_classifiers samples, number_of_features
      end
      best_index = -1
      best_error = Float::MAX
      classifiers.each_with_index do |classifier, i|
        classifier.error = 0.0
        samples.each_with_index do |sample, j|
          y = sample[@y_index]
          if classifier.classify(sample).to_f != y
            classifier.increase_error weights[j]
          end
        end
        if classifier.error < best_error
          best_error = classifier.error
          best_index = i
        end
      end
      best = classifiers[best_index]
      if !Config::USE_RANDOM_WEAK_CLASSIFIERS
        classifiers.delete_at best_index
      end
      best
    end

    private

    def generate_random_classifiers samples, number_of_features
      classifiers = []
      statistics = features_satistics samples
      0.upto Config::NUMBER_OF_RANDOM_CLASSIFIERS - 1 do
          feature_number = rand number_of_features
          info = statistics[feature_number]
          split = rand * info.rng + info.min
          classifiers << WeakClassifier.new(feature_number, split)
      end
      classifiers
    end

    def generate_all_possible_classifiers samples, number_of_features
      if @classifiers_cache.size == 0
        matrix = []
        0.upto number_of_features - 1 do
          matrix << []
        end
        samples.each do |sample|
          0.upto number_of_features - 1 do |i|
            sample_value = sample[i]
            matrix[i] << sample_value
          end
        end
        matrix.each_with_index do |entry, i|
          entry = entry.uniq
          entry.each do |uniq_value|
            @classifiers_cache << WeakClassifier.new(i, uniq_value)
          end
        end
      end
      @classifiers_cache
    end
  end
end
