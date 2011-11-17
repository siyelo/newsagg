module NewsAgg
  module Trainer
    def self.train
      Category.all.each do |category|
        contents = []

        category.seeds.each do |seed|
          parser = NewsAgg::Parser::Html.new(seed[:url], seed[:selector])
          contents << parser.content
        end

        training_set = TrainingSet.new(category.name, contents.join(' '))
        training_set.save
      end
    end
  end
end
