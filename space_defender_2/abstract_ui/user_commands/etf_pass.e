note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PASS
inherit
	ETF_PASS_INTERFACE
create
	make
feature -- command
	pass
    	do
			-- perform some update on the model state
			if(model.game_start=false) then
				model.error.set_state ("  Command can only be used in game.")
			else
			model.reset_error_game_counter
			model.incre_normal_game_counter
			model.pass
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
