note
	description: "Summary description for {SPECIAL_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPECIAL_ACTION
	inherit
	ACTION
	redefine
		state
	end

create
	make

feature  -- Initialization

	state:STRING
	DO
		result:="special"
	end

end
