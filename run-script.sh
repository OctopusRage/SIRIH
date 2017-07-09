rails s
rake resque:work QUEUE='*'
bundle exec rake resque:scheduler
