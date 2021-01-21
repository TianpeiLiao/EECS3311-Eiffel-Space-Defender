note
	description: "Summary description for {ENEMY_PROJECTILE_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_ACTION
	inherit
		PROJECTILE_ACTION


create
	make,make_collide_e,make_deep_twin,make_collide_with_enemy_p,make_collide_with_starfighter,make_collide_with_friendly_p
feature
	enemy:ENEMY
	damage:INTEGER
feature {NONE} -- Initialization

	--constructor of no collision, state can only be move
	make(s:STRING;p:PROJECTILE)
			-- Initialization for `Current'.
		do
			create enemy.make (0, 0, 0, "", 0, 0)
			model:=ma.m
			state:=s
			projectile:=p
		end
	make_deep_twin(s:STRING;p:PROJECTILE)
		do
			create enemy.make (0, 0, 0, "", 0, 0)
			model:=ma.m
			state:=s
			projectile:=p
		end
	--constructor of collision, there are 4 cases
	make_collide_e(s:STRING;e:ENEMY;p:PROJECTILE)
	do
		enemy:=e
		model:=ma.m
		state:=s
		projectile:=p
	end

	make_collide_with_friendly_p(p:PROJECTILE)
	do
			create enemy.make (0, 0, 0, "", 0, 0)
			model:=ma.m
			state:="collide with friendly p"
			projectile:=p
	end

	make_collide_with_enemy_p(p:PROJECTILE)
	do
			create enemy.make (0, 0, 0, "", 0, 0)
			model:=ma.m
			state:="collide with enemy p"
			projectile:=p
	end

	make_collide_with_starfighter(d:INTEGER)
	do
		create enemy.make (0, 0, 0, "", 0, 0)
		model:=ma.m
		state:="collide with starfighter"
		create projectile.make ("", 0, 0)
		damage:=d
	end

feature
	print_e_action:STRING
	do
		model:=ma.m
		result:=""
		--if the starfighter has been destroyed, still need to display the projectile?
		if(state~"move" ) then
			if(projectile.col_before>=1 and projectile.col_before<=model.warzone.col and projectile.col>=1 and projectile.col<=model.warzone.col and projectile.row>=1 and projectile.row<=model.warzone.row) then
				result:="    A enemy projectile(id:"+projectile.id.out+") moves: ["+model.alphabit.at (projectile.row_before)+","+projectile.col_before.out
				+"] -> [" +model.alphabit.at (projectile.row)+","+projectile.col.out+"]%N"
			elseif(projectile.col_before>=1 and projectile.col_before<=model.warzone.col and projectile.row_before>=1) then
				result:="    A enemy projectile(id:"+projectile.id.out+") moves: ["+model.alphabit.at (projectile.row_before)+","+projectile.col_before.out
				+"] -> out of board%N"
				projectile.set_damage(0)
			end
		elseif(state~"collide enemy" and enemy.row>=1 and enemy.row<=model.warzone.row) then
			result:= "      The projectile collides with "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") at location ["+model.alphabit.at (enemy.row)+
			","+projectile.col.out+"], healing "+projectile.damage.out+" damage.%N"
		elseif(state~"collide with friendly p") then
			result:="      The projectile collides with friendly projectile(id:"+projectile.id.out+") at location ["+model.alphabit.at (projectile.row)+
			","+projectile.col.out+"], negating damage.%N"
		elseif(state~"collide with enemy p") then
			result:="      The projectile collides with enemy projectile(id:"+projectile.id.out+") at location ["+model.alphabit.at (projectile.row)+
			","+projectile.col.out+"], combining damage.%N"
		elseif(state~"collide with starfighter") then
			result:= "      The projectile collides with "+"Starfighter"+"(id:"+"0"+") at location ["+model.alphabit.at (model.starfighter.row)+
			","+model.starfighter.col.out+"], dealing "+damage.out+" damage.%N"
		end
	end
end
