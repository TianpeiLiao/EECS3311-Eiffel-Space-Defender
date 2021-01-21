note
	description: "Summary description for {F_COLLISION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	F_COLLISION

create
	make_p_c,make_e_c,make_friendly_p_collision
feature
	model:ETF_MODEL
	ma:ETF_MODEL_ACCESS
	collision_p:PROJECTILE
	collision_e:ENEMY
	row,col,damage:INTEGER
	starfighter:STARFIGHTER
	collide_with:STRING
	--type=s means the starfighter collides with
	--typ=e means the enemy collides with
	type:STRING
feature -- Initialization

	make_p_c(r,c:INTEGER;p:PROJECTILE;t:STRING)
		do
			type:=t
			model:=ma.m
			row:=r
			col:=c
			collision_p:=p
			create collision_e.make (0, 0, 0, "", 0, 0)
			starfighter:=model.starfighter
			
			collision_p.set_collide (true)
			collide_with:="p"
			if(starfighter.health<=0) then
				starfighter.set_health (0)
			end
		end


	make_e_c(r,c:INTEGER;e:ENEMY;t:STRING)

		do
			type:=t
			model:=ma.m
			row:=r
			col:=c
			collision_e:=e
			damage:=e.health
			create collision_p.make_enemy (0)
			starfighter:=model.starfighter

			collide_with:="e"
			e.dec_health (e.health)
			if(starfighter.health<0) then
				starfighter.set_health (0)
			end
		end

	make_friendly_p_collision(r,c:INTEGER;p:PROJECTILE;t:STRING)
		do
			type:=t
			model:=ma.m
			row:=r
			col:=c
			collision_p:=p
			create collision_e.make (0, 0, 0, "", 0, 0)
			starfighter:=model.starfighter

			collision_p.set_collide (true)
			collide_with:="friendly p"
			if(starfighter.health<=0) then
				starfighter.set_health (0)
			end
		end
feature --commands
	print_c:STRING
	do
		model:=ma.m
		result:=""
		if(collide_with~"p") then
			if(type~"s") then
				result:="      The Starfighter collides with enemy projectile(id:"+collision_p.id.out+") at location [" + model.alphabit.at (row)+","+
				col.out+"], taking " + (collision_p.damage-model.starfighter.armour).out+" damage.%N"
			end
		elseif(collide_with~"friendly p") then
			result:="      The Starfighter collides with friendly projectile(id:"+collision_p.id.out+") at location [" + model.alphabit.at (row)+","+
				col.out+"], taking " + (collision_p.damage-model.starfighter.armour).out+" damage.%N"
		elseif(collide_with~"e") then
			if(type~"s") then
				result:="      The Starfighter collides with "+collision_e.enemy_type+"(id:" + collision_e.enemy_id.out+") at location [" + model.alphabit.at (row)
				+"," + col.out+"], trading "+ damage.out + " damage.%N"
			end
		end
	end


end
