module AdaBoost

  class Evaluator

    def initialize(classifier)
      @classifier = classifier
      @threshold = Float::MAX
    end

    def evaluate(test_set)
      contingency_table = ContingencyTable.new
      test_set.each do |sample|
        y = sample[@classifier.y_index]
        h = if Config::USE_THRESHOLD_CLASSIFICATION
          classify_using_threshold(sample)
        else
          classify_normally(sample)
        end
        contingency_table.add_prediction(y, h)
      end
      contingency_table
    end

    def used_feature_numbers(unique = false)
      used_feature_numbers = []
      @classifier.weak_classifiers.each do |weak_classifier|
        used_feature_numbers << weak_classifier.feature_number
      end
      unique ? used_feature_numbers.uniq : used_feature_numbers
    end

    def feature_occurrences
      used_numbers = used_feature_numbers
      occurrences = {}
      used_numbers.each do |number|
        occurrences[number] = 0 if occurrences[number].nil?
        occurrences[number] += 1
      end
      occurrences
    end

    private

    def threshold
      if @threshold == Float::MAX
        @threshold = 0
        @classifier.weak_classifiers.each do |weak_classifier|
          @threshold += weak_classifier.alpha / 2.0
        end
      end
      @threshold
    end

    def classify_normally(sample)
      @classifier.classify(sample > 0) ? 1 : -1
    end

    def classify_using_threshold(sample)
      score = 0.0
      @classifier.weak_classifiers.each do |weak_classifier|
        if sample[weak_classifier.feature_number] > weak_classifier.split
          score += weak_classifier.alpha
        end
      end
      score > threshold ? 1 : -1
    end
  end
end
