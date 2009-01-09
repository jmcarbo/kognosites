# Install hook code here

system("cp '#{RAILS_ROOT}/vendor/plugins/rjs_behaviors/assets/lowpro.js' '#{RAILS_ROOT}/public/javascripts/lowpro.js'")

puts "======================================================"
puts "- Please add the folowing line to your routes.rb file:"
puts "  map.behaviour 'javascripts/behaviours/:action.js',"
puts "    :controller => 'behaviours', :format => 'js'"
puts "- Please add the lowpro.js file to your layouts:"
puts "  <%= javascript_include_tag 'lowpro' %>"
puts "======================================================"
