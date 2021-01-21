note
	description: "Summary description for {SILVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SILVER
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
			max_size:=1
			points:=2
			name:=""
			model:=ma.m
		end

end
