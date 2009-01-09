class User < ActiveRecord::Base
  model_stamper
  stampable

		# Authorization plugin config
    acts_as_authorized_user
    acts_as_authorizable
		# End Authorization plugin config


  acts_as_authentic

end
