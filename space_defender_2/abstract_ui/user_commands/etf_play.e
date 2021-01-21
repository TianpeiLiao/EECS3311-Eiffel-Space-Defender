note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		require else
			play_precond(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
    	do
    		if(model.setM=true and model.game_start=false) then
    			model.error.set_state ("  Already in setup mode.")
			-- perform some update on the model state
			elseif(model.setM=false and model.game_start=true) then

				model.error.set_state ("  Already in a game. Please abort to start a new one.")
			elseif(g_threshold > f_threshold or f_threshold > c_threshold or c_threshold > i_threshold or i_threshold > p_threshold) then
				model.error.set_state ("  Threshold values are not non-decreasing.")
			else
			model.play (row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
