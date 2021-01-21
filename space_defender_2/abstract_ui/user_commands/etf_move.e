note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
    	do
			-- perform some update on the model state
			if(model.game_start=false) then
				model.error.set_state ("  Command can only be used in game.")
			elseif((row<=0 or row>model.warzone.row or column<=0 or column>model.warzone.col) and model.game_start=true) then
				model.error.set_state ("  Cannot move outside of board.")
			elseif(row=model.starfighter.row and column=model.starfighter.col) then
				model.error.set_state ("  Already there.")
			elseif(distance(model.starfighter.row,model.starfighter.col,row,column) > model.starfighter.move) then
				model.error.set_state ("  Out of movement range.")
			elseif(distance(model.starfighter.row,model.starfighter.col,row,column)*model.starfighter.move_cost > model.starfighter.energy+model.starfighter.r2) then
				model.error.set_state ("  Not enough resources to move.")
			else
			model.move (row, column)
			model.incre_normal_game_counter
			model.reset_error_game_counter
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

    distance(s_r,s_c,r,col:INTEGER):INTEGER
		local
			diff_row,diff_col:INTEGER
		do

			diff_row := s_r-r
			diff_col:=s_c-col
			diff_row:=diff_row.abs
			diff_col:=diff_col.abs
			result:=diff_row+diff_col
		end

end
