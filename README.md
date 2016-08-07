# AdaBoostGem
AdaBoost implementation using Ruby.

```
require 'adaboost'
require 'csv'
require 'open-uri'

class TrainModelJob < ActiveJob::Base

  def perform(*args)
    url = 'http://dalmirdasilva.com/static/australian.csv'
    training_set = nil
    open(url) do |f|
        training_set = CSV.parse f, :converters => :float
    end
    test_length = (0.4 * training_set.size).to_i
    test = training_set[0..test_length - 1]
    train = training_set[test_length..-1]
    y_index = test[0].size - 1
    adaboost = AdaBoost::AdaBoost.new 100, y_index
    adaboost.train train
    evaluator = AdaBoost::Evaluator.new adaboost
    puts evaluator.evaluate(test).to_s
#    puts evaluator.used_feature_numbers
    puts evaluator.feature_occurrences
  end
end
 ```