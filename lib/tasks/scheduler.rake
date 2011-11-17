require_relative '../../lib/newsagg'

desc "Crawl web pages"
task :crawl do
  puts "!! Crawling start..."
  NewsAgg::Crawler.start
  puts "!! Crawling end."
end

require_relative '../../lib/newsagg'

desc "Training sets for classifier"
task :train do
  puts "!! Trainer start..."
  NewsAgg::Trainer.train
  puts "!! Trainer end."
end
