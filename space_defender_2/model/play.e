note
	description: "Summary description for {PLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY
create
	make,make_empty
feature --attributes
	row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold:INTEGER
feature --commands
	model:ETF_MODEL
	make(rowA,col,n1,n2,n3,n4,n5:INTEGER)
		local
			ma:ETF_MODEL_ACCESS
		do

			model:=ma.m
			row:=rowA
			column:=col
			g_threshold:=n1
			f_threshold:=n2
			c_threshold:=n3
			i_threshold:=n4
			p_threshold:=n5
			model.set_state_counter (2)
		end
	make_empty
		local
			ma:ETF_MODEL_ACCESS
		do
			model:=ma.m
		end

end
