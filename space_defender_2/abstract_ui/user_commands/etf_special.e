note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SPECIAL
inherit
	ETF_SPECIAL_INTERFACE
create
	make
feature -- command
	special
    	do
			-- perform some update on the model state

			if(model.game_start=false) then
				model.error.set_state ("  Command can only be used in game.")
			else
			model.special
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
