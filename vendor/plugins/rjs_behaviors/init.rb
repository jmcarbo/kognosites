# Include hook code here
::ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.send :include, ::RjsBehaviors::JavaScriptGenerator

config.after_initialize do
  ::ActionController::Base.send :include, ::RjsBehaviors::ActionController
  ::ActionView::Template.register_template_handler('bjs', ::RjsBehaviors::Bjs)
end
