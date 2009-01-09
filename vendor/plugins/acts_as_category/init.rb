ActiveRecord::Base.send :include, ActiveRecord::Acts::Category
ActiveRecord::Base.send :include, ActiveRecord::Acts::CategoryContent
ActionView::Base.send :include, ActsAsCategoryHelper
