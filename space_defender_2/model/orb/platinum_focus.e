note
	description: "Summary description for {PLATINUM_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLATINUM_FOCUS
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
			name:="platinum"
			max_size:=3
			award:=2
			model:=ma.m
		end

end
