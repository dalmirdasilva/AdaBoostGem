module AdaBoost

  class AdaBoost

    attr_reader :weak_classifiers, :y_index

    def initialize number_of_classifiers, y_index
      @weak_classifiers = []
      @weak_learner = WeakLearner.new y_index
      @number_of_classifiers = number_of_classifiers
      @weights = []
      @y_index = y_index
    end

    def train samples
      if Config::OVER_SAMPLING_TRAINING_SET 
        resampler = Resampler.new @y_index
        resampler.over_sample samples
      end
      initialize_weights samples
      0.upto @number_of_classifiers - 1 do |i|
        weak_classifier = @weak_learner.generate_weak_classifier samples, @weights
        weak_classifier.compute_alpha
        update_weights weak_classifier, samples
        @weak_classifiers << weak_classifier
        yield i, weak_classifier if block_given? 
      end
    end

    def classify sample
      score = 0.0
      @weak_classifiers.each do |weak_classifier| 
        score += weak_classifier.classify_with_alpha sample
      end
      score
    end

    def self.build_from_model model, y_index = 0
      classifiers = model.weak_classifiers
      adaboost = AdaBoost.new classifiers.size, y_index
      classifiers.each do |classifier|
        adaboost.weak_classifiers << WeakClassifier.new(classifier.feature_number, classifier.split, classifier.alpha)
      end
      adaboost
    end

    private

    def initialize_weights samples
      samples_size = samples.size.to_f
      negative_weight = 1 / samples_size
      positive_weight = negative_weight
      if Config::INCORPORATE_COST_SENSITIVE_LEARNING
        analyzer = FeaturesAnalyzer.new @y_index
        distribution = analyzer.analyze(samples).distribution
        positive_rate = distribution.positive / samples_size
        negative_rate = distribution.negative / samples_size
        normalizing_constant = distribution.negative * positive_rate + distribution.positive * negative_rate
        positive_weight = positive_rate / normalizing_constant.to_f
        negative_weight = negative_rate / normalizing_constant.to_f
      end
      samples.each_with_index do |sample, i|
        y = sample[@y_index]
        if y == -1 
          @weights[i] = positive_weight
        else 
          @weights[i] = negative_weight
        end
      end
    end

    def update_weights weak_classifier, samples
      sum = 0.0
      samples.each_with_index do |sample, i|
        y = sample[@y_index]
        @weights[i] *= Math.exp -(weak_classifier.alpha) * weak_classifier.classify(sample) * y
        sum += @weights[i]
      end
      @weights.each_with_index do |_, i|
        @weights[i] /= sum
      end
    end
  end
end
