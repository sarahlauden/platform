require 'data_validator'

namespace :data do
  desc "validate all activerecord models"
  task validate: :environment do
    dv = DataValidator.new
    
    puts "Invalid record counts:"
    dv.report[:invalids].each do |class_name, invalids|
      puts "#{class_name.to_s.camelcase}: #{invalids.size}"
    end
    
    puts "\nSUCCESS: #{dv.report[:valid] ? 'YES' : 'NO'}\n\n"
  end
end
