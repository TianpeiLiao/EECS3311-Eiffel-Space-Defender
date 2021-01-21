note
	description: "Summary description for {POWER_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POWER_STATE
inherit
	STATE_SETUP
	redefine
		out,make,print_state
	end
create
	make
feature --attributes
	powers:ARRAY[POWER]
feature --queries
	make
	local
		recall,repair,overcharge,deploy,orbital:POWER
		w_empty:WEAPON
	do
		state:="power setup"
		create recall.make ("Recall (50 energy): Teleport back to spawn.", 50,"recall")
		create repair.make ("Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.", 50,"repair")
		create overcharge.make ("Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.", 50,"overcharge")
		create deploy.make ("Deploy Drones (100 energy): Clear all projectiles.", 100,"deploy")
		create orbital.make ("Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.", 100,"orbital")
		create arrays.make_empty
		create powers.make_empty
		selected_index:=1
		powers.force(recall,powers.count+1)
		powers.force(repair,powers.count+1)
		powers.force(overcharge,powers.count+1)
		powers.force(deploy,powers.count+1)
		powers.force(orbital,powers.count+1)

		create w_empty.make (0, 0, 0, 0, 0, 0, 0, 0, "")
		arrays.force (w_empty, arrays.count+1)
		arrays.force (w_empty, arrays.count+1)
		arrays.force (w_empty, arrays.count+1)
		arrays.force (w_empty, arrays.count+1)
		arrays.force (w_empty, arrays.count+1)
		model:=ma.m
		create projectiles.make_empty
		selected_type:=powers.at (selected_index).type_power
	end

	print_state:STRING
	do
		model:=ma.m
	result:=""
	if (model.debug_mode=false) then
		result:="  state:power setup, normal, ok%N"
	else
		result:="  state:power setup, debug, ok%N"
	end
	end
	out:STRING
	do
		Result:=print_state+
				"  1:Recall (50 energy): Teleport back to spawn.%N"+
  				"  2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.%N"+
  				"  3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.%N"+
  				"  4:Deploy Drones (100 energy): Clear all projectiles.%N"+
  				"  5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.%N"
  				selected_type:=powers.at (selected_index).type_power
  				result:=result+"  Power Selected:"+selected_type
	end
end
