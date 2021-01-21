note
	description: "Summary description for {MOVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE
	inherit
		ACTION
		redefine
			state
		END

create
	make

feature
	state:STRING
	DO
		result:="move"
	end

end
