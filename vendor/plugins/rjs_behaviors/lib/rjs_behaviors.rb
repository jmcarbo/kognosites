# RjsBehaviors

module RjsBehaviors  # :nodoc:
  module JavaScriptGenerator
    def behaviors(options={}, &block)
      ::RjsBehaviors::BehavioursGenerator.new(self, options, &block)
    end
  end
  
  module ActionController
    def self.included(target) # :nodoc:
      target.class_eval %{
        alias_method :render_without_rjs_behaviours, :render
        
        def render(*args, &block)
          if args.first == :behaviours
            render_behaviours(args.extract_options!, &block)
          else
            render_without_rjs_behaviours(*args, &block)
          end
        end
      }
    end
    
    # render some behaviours straight from the controller
    # 
    #   render :behaviours do ... end
    #   render_behaviours do ... end
    #   render :behaviours, :cached => true do ... end
    #   render_behaviours :cached => true do ... end
    # 
    def render_behaviours(options={}, &block)
      if options[:cached] and ::ActionController::Base.perform_caching
        javascript = render_to_string :update do |page|
          page.behaviors(options, &block)
        end
        javascript_path = File.join(RAILS_ROOT, 'public', behaviour_path(params[:action].to_s))
        FileUtils.mkdir_p(File.dirname(javascript_path))
        File.open(javascript_path, "w+") { |f| f.write javascript }
        redirect_to behaviour_path(params[:action].to_s)
      else
        render :update do |page|
          page.behaviors(options, &block)
        end
      end
    end
  end
  
  class BehavioursGenerator
    
    def initialize(context, options={}, &block) # :nodoc:
      options.reverse_merge!(:reassign => false)
      @first = true
      @generator = context
      @generator << 'Event.addBehavior.reassignAfterAjax = true;' if options[:reassign]
      @generator << 'Event.addBehavior({'
      instance_eval &block
      @generator << '});'
    end
    
    def behavior(selector, behavior=nil, *args, &block)
      @generator << (@first ? '' : ',')+"'#{selector}' : "
      
      if behavior.nil?
        @generator << "function() {"
        this = ActionView::Helpers::JavaScriptProxy.new(@generator, 'this')
        class << this ; def to_json ; '$(this)' ; end ; end
        @generator.instance_variable_get(:@context).instance_exec(@generator, this, &block)
        @generator << '}'
      elsif args.size > 0
        @generator << "#{behavior}(#{@generator.send(:arguments_for_call, args, block)})"
      else
        @generator << "#{behavior}"
      end
      
      @first = false
    end
    
  end
  
  class Bjs < ::ActionView::TemplateHandler
    include ::ActionView::TemplateHandlers::Compilable
  
    def self.line_offset
      3
    end
  
    def compile(template)
      "controller.response.content_type ||= Mime::JS\n" +
      "update_page do |page|\npage.behaviors do\n#{template.source}\nend\nend"
    end
  
    def cache_fragment(block, name = {}, options = nil) #:nodoc:
      @view.fragment_for(block, name, options) do
        begin
          debug_mode, ActionView::Base.debug_rjs = ActionView::Base.debug_rjs, false
          eval('page.to_s', block.binding)
        ensure
          ActionView::Base.debug_rjs = debug_mode
        end
      end
    end
  end
end
