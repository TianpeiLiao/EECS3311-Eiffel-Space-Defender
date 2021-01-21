note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_NEXT
inherit
	ETF_SETUP_NEXT_INTERFACE
create
	make
feature -- command
	setup_next(state: INTEGER_32)
		require else
			setup_next_precond(state)
    	do
			-- perform some update on the model state
			if(model.game_start=true or model.setm=false) then
				model.error.set_state ("  Command can only be used in setup mode.")
			elseif(model.state_counter+state<=model.states_setup.count) then
			model.set_state_counter (model.state_counter+state)
			else
				model.set_game_start (true)
				model.reset_error_game_counter
				model.start
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
