note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT
	inherit
	ENEMY
	redefine
		act,pre_act
	end


create
	make,make_grunt

feature -- Initialization

	make_grunt(locate_row,locate_col,e_id:INTEGER)
			-- Initialization for `Current'.
		do

			points:=2
			create {SILVER} orb.make
			enemy_id:=e_id
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			health:=100
			maxhealth:=100
			armour:=1
			r1:=1
			vision:=5
			row:=locate_row
			col:=locate_col
			enemy_type:="Grunt"
			model:=ma.m
			symbol:="G"
			create enemy_projectiles.make_empty
			create projectile.make ("<", 15,0)
			model.inc_enemy_id
			collision_m:=""
			model.round.enemys.force (current, model.round.enemys.count+1)
			model.set_enemy_spawn (true)
			model.set_enemy_spawn_mes (model.round.print_enemy_spawn_mes (enemy_id, "Grunt", row, col))
			model.set_enemy_spawn_mes (check_collide_from_spawn)
			set_seen_by_starfighter(distance(current,model.starfighter)<=model.starfighter.vision)
				set_can_see_starfighter(distance(current,model.starfighter)<=current.vision)
		end
feature
	pre_act(s:STRING)
	local
		enemy_action1:ENEMY_ACTION
	do
		set_pre_action(true)
		create enemy_action1.make_empty
----		--apply regen
--			if(maxhealth-health>=r1) then
--				inc_health(r1)
--			elseif(maxhealth-health<r1) then
--				inc_health(maxhealth-health)
--			end
		if(health>0) then
		--preemptive action
			if(s~"pass") then
				set_health(health+10)
				set_maxhealth(maxhealth+10)
				enemy_action1.set_state_gain (10, current)
				model.set_enemy_pre_action (enemy_action1.print_action)
			elseif(s~"special") then
				set_health(health+20)
				set_maxhealth(maxhealth+20)
				enemy_action1.set_state_gain (20, current)
				model.set_enemy_pre_action (enemy_action1.print_action)
				end
			end
	end


	act(s:STRING)
	local
	pro:PROJECTILE
	enemy_action1,enemy_action2,enemy_action3:ENEMY_ACTION
	do

		set_pre_action(false)
		create enemy_action1.make_empty
		create enemy_action2.make_empty
		create enemy_action3.make_empty
		--apply regen
			if(maxhealth-health>=r1) then
				inc_health(r1)
			elseif(maxhealth-health<r1) then
				inc_health(maxhealth-health)
			end
		if(health>0) then
			--
			if(can_see_Starfighter=false and symbol~"G") then
				--SET enemy move action
				move_action(row,col-2)

				if(if_onboard and model.starfighter.health>0 and health>0) then
				create pro.make_enemy (15)
				pro.set_damage (15)
				pro.set_id (model.projectile_id)
				enemy_action3.set_state ("fire projectile")
				enemy_action3.set_projectile_id (pro.id)
				enemy_action3.set_rc (row, col-1)
				model.set_enemy_action (enemy_action3.print_action)
				pro.set_r_c (row, col-1)


				pro.set_move (4)
				add_projectile(pro)

				model.add_total_projectile (pro)
				end
			elseif(can_see_Starfighter=true and symbol~"G") then
				move_action(row,col-4)
				if(if_onboard and model.starfighter.health>0 and health>0) then
				create pro.make_enemy (15)
				pro.set_damage (15)
				pro.set_id (model.projectile_id)
				--set enemy fire p action
				enemy_action3.set_state ("fire projectile")
				enemy_action3.set_projectile_id (pro.id)
				enemy_action3.set_rc (row, col-1)
				model.set_enemy_action (enemy_action3.print_action)
				pro.set_r_c (row, col-1)



				pro.set_move (4)
				add_projectile(pro)

				model.add_total_projectile (pro)
				end

			end

		end
	end
end
