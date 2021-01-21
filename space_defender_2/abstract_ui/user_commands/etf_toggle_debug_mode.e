note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TOGGLE_DEBUG_MODE
inherit
	ETF_TOGGLE_DEBUG_MODE_INTERFACE
create
	make
feature -- command
	toggle_debug_mode
    	do
			-- perform some update on the model state
			model.incre_error_game_counter
			model.set_debug_mode (not model.debug_mode)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
