class DataValidator
  class << self
    def classes
      Rails.application.eager_load!
      ActiveRecord::Base.descendants.select(&:table_exists?).reject{|d| d.name =~ /migration/i}.sort_by(&:name)
    end
  end
  
  def report
    return @report if defined?(@report)
    
    @report = {valid: true, models: {}}
    
    self.class.classes.each do |model_class|
      class_name = model_class.name.underscore.to_sym
      invalid_ids = invalids(model_class)
      
      @report[:models][class_name] = {
        total: model_class.count,
        valid: model_class.count - invalid_ids.size,
        invalid: invalid_ids.size,
        invalid_ids: invalid_ids
      }

      @report[:valid] = false unless invalid_ids.empty?
    end
    
    @report
  end
  
  def invalids model_class
    model_class.all.reject(&:valid?).map(&:id)
  end
end