note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state

			if(model.game_start=false) then
				model.error.set_state ("  Command can only be used in game.")
			else

			model.fire
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
