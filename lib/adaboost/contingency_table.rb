module AdaBoost

  class ContingencyTable

    def initialize
      @table = [[0, 0], [0, 0]]
    end

    def true_positive
      @table[1][1]
    end

    def false_positive
      @table[0][1]
    end

    def true_negative
      @table[0][0]
    end

    def false_negative
      @table[1][0]
    end

    def add_prediction y, h
      @table[class_to_index(y)][class_to_index(h)] += 1
    end

    def outcome_positive
      true_positive + false_positive
    end

    def outcome_negative
      true_negative + false_negative
    end

    def total_population
      @table[0][0] + @table[0][1] + @table[1][0] + @table[1][1]
    end

    def predicted_condition_positive
      true_positive + false_positive
    end

    def predicted_condition_negative
      false_negative + true_negative
    end

    def condition_positive
      true_positive + false_negative
    end

    def condition_negative
      false_positive + true_negative
    end

    def prevalence
      condition_positive / total_population.to_f
    end

    def true_positive_rate
      true_positive / condition_positive.to_f
    end

    def recall
      true_positive_rate
    end

    def sensitivity
      true_positive_rate
    end

    def false_positive_rate
      false_positive / condition_negative.to_f
    end

    def fall_out
      false_positive_rate
    end

    def false_negative_rate
      false_negative / condition_positive.to_f
    end

    def true_negative_rate
      true_negative / condition_negative.to_f
    end

    def specificity
      true_negative_rate
    end

    def accuracy
      (true_positive + true_negative) / total_population.to_f
    end

    def positive_predictive_value
      true_positive / outcome_positive.to_f
    end

    def precision
      positive_predictive_value
    end

    def false_discovery_rate
      false_positive / outcome_positive.to_f
    end

    def false_omission_rate
      false_negative / outcome_negative.to_f
    end

    def negative_predictive_value
      true_negative / outcome_negative.to_f
    end

    def positive_likelihood_ratio
      true_positive_rate / false_positive_rate.to_f
    end

    def negative_likelihood_ratio
      false_negative_rate / true_negative_rate.to_f
    end

    def diagnostic_odds_ratio
      positive_likelihood_ratio / negative_likelihood_ratio.to_f
    end

    def to_s
      "\nTotal population: %d\t \
      \nCondition positive: %d\t \
      \nCondition negative: %d\t \
      \nPredicted Condition positive: %d\t \
      \nPredicted Condition negative: %d\t \
      \nTrue positive: %d\t \
      \nTrue negative: %d\t \
      \nFalse Negative: %d\t \
      \nFalse Positive: %d\t \
      \nPrevalence = Σ Condition positive / Σ Total population: %f\t \
      \nTrue positive rate (TPR) = Σ True positive / Σ Condition positive: %f\t \
      \nFalse positive rate (FPR) = Σ False positive / Σ Condition negative: %f\t \
      \nFalse negative rate (FNR) = Σ False negative / Σ Condition positive: %f\t \
      \nTrue negative rate (TNR) = Σ True negative / Σ Condition negative: %f\t \
      \nAccuracy (ACC) = Σ True positive \ Σ True negative / Σ Total population: %f\t \
      \nPositive predictive value (PPV) = Σ True positive / Σ Test outcome positive: %f\t \
      \nFalse discovery rate (FDR) = Σ False positive / Σ Test outcome positive: %f\t \
      \nFalse omission rate (FOR) = Σ False negative / Σ Test outcome negative: %f\t \
      \nNegative predictive value (NPV) = Σ True negative / Σ Test outcome negative: %f\t \
      \nPositive likelihood ratio (LR\) = TPR / FPR: %f\t \
      \nNegative likelihood ratio (LR−) = FNR / TNR: %f\t \
      \nDiagnostic odds ratio (DOR) = LR+ / LR−: %f\t" %
      [
        total_population,
        condition_positive,
        condition_negative,
        predicted_condition_positive,
        predicted_condition_negative,
        true_positive,
        true_negative,
        false_negative,
        false_positive,
        prevalence,
        true_positive_rate,
        false_positive_rate,
        false_negative_rate,
        true_negative_rate,
        accuracy,
        positive_predictive_value,
        false_discovery_rate,
        false_omission_rate,
        negative_predictive_value,
        positive_likelihood_ratio,
        negative_likelihood_ratio,
        diagnostic_odds_ratio
      ]
    end

    def class_to_index k
      k > 0 ? 1 : 0
    end
  end
end
