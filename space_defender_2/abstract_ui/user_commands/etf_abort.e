note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ABORT
inherit
	ETF_ABORT_INTERFACE
create
	make
feature -- command
	abort
    	do
			-- perform some update on the model state
			if(model.game_start=false and model.setM=false) then
				model.error.set_state ("  Command can only be used in setup mode or in game.")
			else
			model.set_abort
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
