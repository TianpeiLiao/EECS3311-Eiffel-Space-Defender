note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR
inherit
	ENEMY
	redefine
		act,pre_act
	end


create
	make,make_interceptor


feature -- Initialization
	make_interceptor(locate_row,locate_col,e_id:INTEGER;c_b_c:BOOLEAN)
			-- Initialization for `Current'.
		do
			create {BRONZE} orb.make
			just_created_by_c:=c_b_c
			points:=1
			enemy_id:=e_id
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			health:=50
			maxhealth:=50
			vision:=5
			row:=locate_row
			col:=locate_col
			enemy_type:="Interceptor"
			model:=ma.m
			symbol:="I"
			create enemy_projectiles.make_empty
			create projectile.make ("<", 15,0)
			model.inc_enemy_id
			collision_m:=""
			model.round.enemys.force (current, model.round.enemys.count+1)
			model.set_enemy_spawn (true)
			model.set_enemy_spawn_mes (model.round.print_enemy_spawn_mes (enemy_id, enemy_type, row, col))
			if(just_created_by_c=false) then
			model.set_enemy_spawn_mes (check_collide_from_spawn)
			end
			set_seen_by_starfighter(distance(current,model.starfighter)<=model.starfighter.vision)
			set_can_see_starfighter(distance(current,model.starfighter)<=current.vision)
		end




	pre_act(s:STRING)
	local
		enemy_action2:ENEMY_ACTION
	do
		if(health>0) then
			set_pre_action(true)
			create enemy_action2.make_empty
			if(just_created_by_C=false) then
			if(s~"fire" and current.if_onboard=true) then
				current.move_action (model.starfighter.row, col)

			end
			end
		end
	end

	act(s:STRING)
	local
		enemy_action2:ENEMY_ACTION
	do
		if(health>0 and model.starfighter.health>0) then
			set_pre_action(false)
			create enemy_action2.make_empty
			if(just_created_by_C=false) then
			if(s/~"fire") then
			move_action(row,col-3)
			end
			end

		end
	end

end
