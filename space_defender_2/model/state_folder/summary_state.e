note
	description: "Summary description for {SUMMARY_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUMMARY_STATE
	inherit
		STATE_SETUP
		redefine
			out,make,print_state
		end
create
	make
feature
	make
	do
		create projectiles.make_empty
		create arrays.make_empty
		state:="setup summary"
		model:=ma.m
		create selected_type.make_empty
	end

	print_state:STRING
	do
		model:=ma.m
	result:=""
	if (model.debug_mode=false) then
		result:="  state:setup summary, normal, ok%N"
	else
		result:="  state:setup summary, debug, ok%N"
	end
	end
feature
	out:STRING
	do
		model:=ma.m
		Result:=		print_state
		result:=result+"  Weapon Selected:" + model.states_setup.at (2).selected_type+"%N"
		result:=result+"  Armour Selected:"   + model.states_setup.at (3).selected_type+"%N"
		result:=result+"  Engine Selected:"+ model.states_setup.at (4).selected_type+"%N"
		result:=result+"  Power Selected:"+model.states_setup.at (5).selected_type


	end
end
