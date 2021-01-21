note
	description: "Summary description for {STATE_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATE_SETUP
inherit
	ANY
	redefine
		out
	end

feature --attributes
	selected_index:INTEGER
	arrays:ARRAY[TYPE_SETUP]
	projectiles:ARRAY[PROJECTILE]
	state:STRING
	model:ETF_MODEL
	ma:ETF_MODEL_ACCESS
	selected_type:STRING
feature --commands
	make
	do
		create state.make_empty
		create arrays.make_empty
		create projectiles.make_empty
		create selected_type.make_empty
		selected_index:=1
		model:=ma.m
	end
	print_state:STRING
	do
		result:=""
	end
	reset
	do
		selected_index:=1
	end

	set_selected_type(ss:STRING)
	do
		selected_type:=ss
	end

	set_state
	DO

	end

	set_index(i:INTEGER)
	do
		selected_index:=i
	end
feature --queries
	out:STRING
	do
		RESULT:=""
	end

end
