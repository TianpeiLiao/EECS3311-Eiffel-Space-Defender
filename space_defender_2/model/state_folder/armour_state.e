note
	description: "Summary description for {ARMOUR_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_STATE
inherit
	STATE_SETUP
	redefine
		out,make,print_state
	end
create
	make
feature --arttrbutes
	none,light,medium,heavy:ARMOUR


feature --queries
	make
	do
		create none.make (50, 0, 0, 0, 1, 0, 1, 0,"None")
		create light.make(75,0,3,0,0,1,2,0,"Light")
		create medium.make(100,0,5,0,0,3,3,0,"Medium")
		create heavy.make(200,0,10,0,-1,5,4,0,"Heavy")
		create arrays.make_empty
		arrays.force(none,arrays.count+1)
		arrays.force(light,arrays.count+1)
		arrays.force(medium,arrays.count+1)
		arrays.force(heavy,arrays.count+1)

		selected_index:=1
		state:="armour setup"
		model:=ma.m
		create projectiles.make_empty
		selected_type:=arrays.at (selected_index).type
	end

	print_state:STRING
	do
		model:=ma.m
	result:=""
	if (model.debug_mode=false) then
		result:="  state:armour setup, normal, ok%N"
	else
		result:="  state:armour setup, debug, ok%N"
	end
	end

	out:STRING
	do

		Result:=
				print_state+
				"  1:None%N"+
				"    Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0%N"+
  				"  2:Light%N"+
  				"    Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1%N"+
  				"  3:Medium%N"+
  				"    Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3%N"+
  				"  4:Heavy%N"+
  				"    Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5%N"
  				selected_type:=arrays.at (selected_index).type
  				Result:=result+"  Armour Selected:"+arrays.at (selected_index).type
	end
end
