note
	description: "Summary description for {DIAMOND_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIAMOND_FOCUS
	inherit
		ORB
	redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create array.make_empty
			max_size:=4
			name:="diamond"
			--no points
			award:=3
			model:=ma.m
		end

end
