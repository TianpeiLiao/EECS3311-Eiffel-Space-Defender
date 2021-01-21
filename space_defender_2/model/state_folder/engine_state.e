note
	description: "Summary description for {ENGINE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_STATE
inherit
	STATE_SETUP
	redefine
		out,make,print_state
	end
create
	make
feature --attributes


feature --queries
	make
	local
	standard,light,armoured	:ENGINE
	do
		create standard.make (10, 60, 1, 12, 8, 2, 0, 2,"Standard")
		create light.make (0, 30, 0, 15, 10, 1, 0, 1,"Light")
		create armoured.make (50, 100, 3, 6, 4, 5, 0, 3,"Armoured")
		create arrays.make_empty
		arrays.force (standard, arrays.count+1)
		arrays.force (light, arrays.count+1)
		arrays.force (armoured, arrays.count+1)
		selected_index:=1
		state:="engine setup"

		model:=ma.m
		create projectiles.make_empty
		selected_type:=arrays.at (selected_index).type

	end

	print_state:STRING
	do
		model:=ma.m
	result:=""
	if (model.debug_mode=false) then
		result:="  state:engine setup, normal, ok%N"
	else
		result:="  state:engine setup, debug, ok%N"
	end
	end
	out:STRING
	do
		Result:=
				print_state+
				"  1:Standard%N"+
    			"    Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2%N"+
  				"  2:Light%N"+
    			"    Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1%N"+
  				"  3:Armoured%N"+
    			"    Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5%N"
    			selected_type:=arrays.at (selected_index).type
    			result:=result+"  Engine Selected:"+selected_type
	end
end
