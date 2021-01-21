note
	description: "Summary description for {POWER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POWER

create
	make
feature --attributes
	type_power,type:STRING
	amount:INTEGER
feature {NONE} -- Initialization

	make(t:STRING;a:INTEGER;tt:STRING)
			-- Initialization for `Current'.
		do
			type:=tt
			type_power:=t
			amount:=a
		end

end
