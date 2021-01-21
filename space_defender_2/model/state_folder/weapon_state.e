note
	description: "Summary description for {WEAPON_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_STATE
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
		standard:WEAPON
		spread:WEAPON
		snipe:WEAPON
		rocket:WEAPON
		splitter:WEAPON
		p_st:PROJECTILE
		p_sp:PROJECTILE
		p_sn:PROJECTILE
		p_r:PROJECTILE
		p_spl:PROJECTILE
	do
		selected_index:=1

		create standard.make (10, 10, 0, 1, 1, 1, 0, 1,"Standard")
		create spread.make (0, 60, 1, 0, 0, 2, 0, 2,"Spread")
		create snipe.make (0, 100, 0, 10, 3, 0, 0, 5,"Snipe")
		create rocket.make (10, 0, 2, 2, 0, 3, 10, 0,"Rocket")
		create splitter.make (0, 100, 0, 0, 0, 5, 0, 10,"Splitter")

		create p_st.make ("Standard", 70, 5)
		create p_sp.make ("Spread", 50, 10)
		create p_sn.make ("Snipe", 1000, 20)
		create p_r.make ("Rocket", 100, 10)
		create p_spl.make ("Splitter", 150, 70)
		create projectiles.make_empty
		projectiles.force (p_st, projectiles.count+1)
		projectiles.force (p_sp, projectiles.count+1)
		projectiles.force (p_sn, projectiles.count+1)
		projectiles.force (p_r, projectiles.count+1)
		projectiles.force (p_spl, projectiles.count+1)


		create arrays.make_empty
		arrays.force (standard, arrays.count+1)
		arrays.force (spread, arrays.count+1)
		arrays.force (snipe, arrays.count+1)
		arrays.force (rocket, arrays.count+1)
		arrays.force (splitter, arrays.count+1)
		state:="weapon setup"
		selected_type:=arrays.at (selected_index).type
		model:=ma.m
	end

	print_state:STRING
	do
		model:=ma.m
	result:=""
	if (model.debug_mode=false) then
		result:="  state:weapon setup, normal, ok%N"
	else
		result:="  state:weapon setup, debug, ok%N"
	end
	end


	out:STRING
	do


		Result:=		print_state+
  						"  1:Standard (A single projectile is fired in front)%N"+
    					"    Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,%N"+
    					"    Projectile Damage:70, Projectile Cost:5 (energy)%N"+
  						"  2:Spread (Three projectiles are fired in front, two going diagonal)%N"+
    					"    Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,%N"+
    					"    Projectile Damage:50, Projectile Cost:10 (energy)%N"+
  						"  3:Snipe (Fast and high damage projectile, but only travels via teleporting)%N"+
   	 					"    Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,%N"+
    					"    Projectile Damage:1000, Projectile Cost:20 (energy)%N"+
  						"  4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)%N"+
    					"    Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,%N"+
    					"    Projectile Damage:100, Projectile Cost:10 (health)%N"+
  						"  5:Splitter (A single mine projectile is placed in front of the Starfighter)%N"+
    					"    Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,%N"+
    					"    Projectile Damage:150, Projectile Cost:70 (energy)%N"
    					selected_type:=arrays.at (selected_index).type
    					Result:=result+"  Weapon Selected:"+arrays.at (selected_index).type
	end

end
