note
	description: "Summary description for {GOLD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOLD
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
			name:=""
			max_size:=1
			points:=3
			model:=ma.m
		end

end
