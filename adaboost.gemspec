Gem::Specification.new do |s|
  s.name        = 'adaboost'
  s.version     = '0.0.1'
  s.date        = '2016-07-25'
  s.summary     = 'AdaBoost classifier!'
  s.description = 'AdaBoost classifier!'
  s.authors     = ['Dalmir da Silva']
  s.email       = 'dalmirdasilva@gmail.com'
  s.files       = ['lib/adaboost.rb', 
                   'lib/adaboost/adaboost.rb',
                   'lib/adaboost/config.rb', 
                   'lib/adaboost/contingency_table.rb',
                   'lib/adaboost/evaluator.rb',
                   'lib/adaboost/features_analyzer.rb', 
                   'lib/adaboost/resampler.rb',
                   'lib/adaboost/weak_classifier.rb',
                   'lib/adaboost/weak_learner.rb']
  s.homepage    = 'http://dalmirdasilva.com/adaboost-classifier'
  s.license     = 'MIT'
end

