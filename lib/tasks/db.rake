namespace :db do
  desc "load dummy data"
  task dummies: :environment do
    load "#{Rails.root}/db/dummies.rb"
  end
end