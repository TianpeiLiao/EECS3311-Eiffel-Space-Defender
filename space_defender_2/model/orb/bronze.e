note
	description: "Summary description for {BRONZE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BRONZE
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
			points:=1
			name:=""
			model:=ma.m
		end

end
