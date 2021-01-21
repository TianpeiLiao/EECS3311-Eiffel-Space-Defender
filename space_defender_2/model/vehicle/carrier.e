note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER
inherit
	ENEMY
	redefine
		act,pre_act
	end


create
	make,make_carrier
feature
	create_i:BOOLEAN

feature -- Initialization

	make_carrier(locate_row,locate_col,e_id:INTEGER)
			-- Initialization for `Current'.
		do
				create {DIAMOND_FOCUS} orb.make
				orb.add_orb (create {GOLD}.make)
				points:=3
				enemy_id:=e_id
				alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
				health:=200
				maxhealth:=200
				armour:=15
				r1:=10
				vision:=15
				row:=locate_row
				col:=locate_col
				enemy_type:="Carrier"
				model:=ma.m
				symbol:="C"
				create enemy_projectiles.make_empty
				create projectile.make ("<", 15,0)
				model.inc_enemy_id
				collision_m:=""
				model.round.enemys.force (current, model.round.enemys.count+1)
				model.set_enemy_spawn (true)
				model.set_enemy_spawn_mes (model.round.print_enemy_spawn_mes (enemy_id, "Carrier", row, col))
				model.set_enemy_spawn_mes (check_collide_from_spawn)
				set_seen_by_starfighter(distance(current,model.starfighter)<=model.starfighter.vision)
				set_can_see_starfighter(distance(current,model.starfighter)<=current.vision)
		end

	pre_act(s:STRING)
	local
		p:PROJECTILE
		enemy_action,enemy_action2,enemy_action3:ENEMY_ACTION
		enemy:ENEMY
	do
		if(health>0) then
		set_pre_action(true)
		model:=ma.m
		create p.make_enemy (100)
		CREATE enemy_action.make_empty
		CREATE enemy_action2.make_empty
		CREATE enemy_action3.make_empty
		if(health>0) then
			if(s~"special") then
				r1:=r1+10
				enemy_action.set_gain_r1 (10, current)
				model.set_enemy_pre_action (enemy_action.print_action)
			end
--			--apply regen
			if(maxhealth-health>=r1) then
				inc_health(r1)
			elseif(maxhealth-health<r1) then
				inc_health(maxhealth-health)
			end
			if(s~"pass") then
				current.move_action (row, col-2)
				if(if_onboard and model.starfighter.health>0 and health>0) then

				if(if_enemy_at(row-1,col)=false) then
				create {INTERCEPTOR} enemy.make_interceptor(row-1, col,model.enemy_id,true)
				enemy_action2.set_enemy (enemy)
				enemy_action2.set_state ("spawn i")
				model.set_enemy_pre_action (enemy_action2.print_action)
				enemy.checkcollide (row, col-1)
				model.set_enemy_action (enemy.collision_m)
				end


				if(if_enemy_at(row+1,col)=false) then
				create {INTERCEPTOR} enemy.make_interceptor(row+1, col,model.enemy_id,true)
				enemy.set_just_created_by_c (true)
				enemy_action3.set_enemy (enemy)
				enemy_action3.set_state ("spawn i")
				model.set_enemy_pre_action (enemy_action3.print_action)
				enemy.checkcollide (row, col-1)
				model.set_enemy_action (enemy.collision_m)
				end
				end
			end

		end
		end
	end

	if_enemy_at(r,c:INTEGER):BOOLEAN
	do
		result:=false
		across
			model.round.enemys is es
		loop
			if(es.row=r and es.col=c and es.if_onboard=true and es.health>0) then
				result:=true
			end
		end
	end

	act(s:STRING)
	local
		p:PROJECTILE
		enemy_action,enemy_action2:ENEMY_ACTION
		enemy:ENEMY
		a:STRING
	do

		if(health>0) then
		set_pre_action(false)
		create p.make_enemy (100)
		CREATE enemy_action.make_empty
		CREATE enemy_action2.make_empty
		if(s/~"pass" and create_i=false) then
			
			if(can_see_starfighter=true) then
				current.move_action (row, col-1)
				if(if_onboard and model.starfighter.health>0) then
				--set action of INTERCEPTOR
				if(if_enemy_at(row,col-1)=false) then
				create {INTERCEPTOR} enemy.make_interceptor(row, col-1,model.enemy_id,true)
				enemy_action2.set_enemy (enemy)
				enemy_action2.set_state ("spawn i")
				model.set_enemy_action (enemy_action2.print_action)
				enemy.checkcollide (row, col-1)
				model.set_enemy_action (enemy.collision_m)

				end
				end
			else
				--set move action
				current.move_action (row, col-2)
			end
		end
		end
	end

end
