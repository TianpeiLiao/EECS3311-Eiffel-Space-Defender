note
	description: "Summary description for {FIRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIRE
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
		result:="fire"
	end


end
