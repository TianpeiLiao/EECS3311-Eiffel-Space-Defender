note
	description: "Summary description for {INITIAL_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INITIAL_STATE
inherit
	STATE_SETUP
	redefine
		out,make,print_state
	end
create
	make

FEATURE
	make
	do
		create projectiles.make_empty
		model:=ma.m
		selected_type:=""
		state:=""
		create arrays.make_empty
	end
	print_state:STRING
	DO
		result:="  state:not started, normal, ok%N"
	end
	out:STRING
	do
		Result:=print_state+"  Welcome to Space Defender Version 2."
	end

end
