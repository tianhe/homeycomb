desc "Rename an App from old_name to new_name"
task :rename_app_to, [:to_name] do |t, args|  
  camelize_to_name = args.to_name.camelize
  underscore_to_name = args.to_name.underscore
  
  replace 'SampleApp', camelize_to_name, 'app/views/layouts/application.html.haml'
  replace 'SampleApp', camelize_to_name, 'config/application.rb'
  replace 'sample_app', underscore_to_name, 'config/initializers/session_store.rb'
  replace 'sample_app', underscore_to_name, '.ruby-gemset'
end

def replace from_string, to_string, file
  puts "Modify: #{file}"
  puts "sed -i.bak s/#{from_string}/#{to_string}/g #{file}"
  `sed -i.bak "s/#{from_string}/#{to_string}/g" "#{file}"`  
  `rm "#{file}.bak"`
end