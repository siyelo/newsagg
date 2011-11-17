path = File.expand_path('../../lib', __FILE__)
$:.unshift(path) if File.directory?(path) && !$:.include?(path)

require_relative '../config'

module NewsAgg

  autoload :Category,    'category'
  autoload :Medium,      'medium'
  autoload :Item,        'item'
  autoload :TrainingSet, 'training_set'
  autoload :Trainer,     'trainer'
  autoload :Crawler,     'crawler'
  autoload :Classifier,  'classifier'


  module Parser
    autoload :Rss,       'parser/rss'
    autoload :Html,      'parser/html'
    autoload :Cleaner,   'parser/cleaner'
  end
end
