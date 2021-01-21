note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_SELECT
inherit
	ETF_SETUP_SELECT_INTERFACE
create
	make
feature -- command
	setup_select(value: INTEGER_32)
		require else
			setup_select_precond(value)
    	do
			-- perform some update on the model state
			if(model.game_start=true or model.state_counter=6 or model.setm=false) THEN
				model.error.set_state ("  Command can only be used in setup mode (excluding summary in setup).")
			elseif(value <= model.states_setup.at (model.state_counter).arrays.count) then
			model.states_setup.at (model.state_counter).set_index (value)
			else
				model.error.set_state ("  Menu option selected out of range.")
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
