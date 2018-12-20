class DscaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  
  def create_controller
    template "app/controllers/controller.rb", "app/controllers/#{plural_file_name}_controller.rb"
    template "spec/controllers/controller_spec.rb", "spec/controllers/#{plural_file_name}_controller_spec.rb"
    template "spec/routing/routing_spec.rb", "spec/routing/#{plural_file_name}_routing_spec.rb"
    
    route "resources :#{plural_name}"
    
    [
      'index.html.erb', 'index.json.jbuilder', 'show.html.erb', 'show.json.jbuilder', 
      'edit.html.erb', 'new.html.erb', '_form.html.erb'
    ].each{|view| template "app/views/#{view}", "app/views/#{plural_name}/#{view}" }
  end
  
  private
  
  def plural_class_name
    plural_name.camelize
  end
  
  def human_title
    human_name.titleize
  end
  
  def plural_human_title
    plural_name.titleize
  end
end
