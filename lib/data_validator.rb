class DataValidator
  class << self
    def classes
      Rails.application.eager_load!
      ActiveRecord::Base.descendants.select(&:table_exists?).reject{|d| d.name =~ /migration/i}.sort_by(&:name)
    end
  end
  
  def report
    return @report if defined?(@report)
    
    @report = {valid: true, invalids: Hash.new(Array.new)}
    
    self.class.classes.each do |model_class|
      class_name = model_class.name.underscore.to_sym
      
      @report[:invalids][class_name] = invalids(model_class)
      @report[:valid] = false unless @report[:invalids][class_name].empty?
    end
    
    @report
  end
  
  def invalids model_class
    model_class.all.reject(&:valid?).map(&:id)
  end
end