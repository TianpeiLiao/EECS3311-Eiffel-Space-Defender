note
	description: "Summary description for {PASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PASS
inherit
	ACTION
	redefine
		state
	end
create
	make

feature 
	state:STRING
	DO
		result:="pass"
	end

end
