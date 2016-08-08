module AdaBoost

  class WeakClassifier

    attr_accessor :error
    attr_reader :feature_number, :split, :alpha

    def initialize(feature_number, split, alpha = 0.0, error = 0.0)
      @feature_number = feature_number
      @split = split
      @error = error
      @alpha = alpha
    end

    def compute_alpha
      @alpha = 0.5 * Math.log((1.0 - @error) / @error)
    end

    def classify(sample)
      sample[@feature_number] > @split ? 1 : -1
    end

    def classify_with_alpha(sample)
      return classify(sample) * @alpha
    end

    def increase_error(amount)
      @error += amount
    end
  end
end
