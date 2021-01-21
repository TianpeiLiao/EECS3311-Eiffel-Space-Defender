note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_BACK
inherit
	ETF_SETUP_BACK_INTERFACE
create
	make
feature -- command
	setup_back(state: INTEGER_32)
		require else
			setup_back_precond(state)
    	do
			-- perform some update on the model state
			if(model.game_start=true or model.setM=false) then
				model.error.set_state ("  Command can only be used in setup mode.")
			elseif(model.state_counter-state<=1) then
				model.set_state_counter (1)
				if(model.state_counter=1) then
					model.set_setM(false)
					model.set_game_start (false)
				end
			else
				model.set_state_counter (model.state_counter-state)
				if(model.state_counter=1) then
					model.set_setM(false)
					model.set_game_start (false)
				end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
