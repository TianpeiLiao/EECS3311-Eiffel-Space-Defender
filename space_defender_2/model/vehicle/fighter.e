note
	description: "Summary description for {FIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIGHTER
inherit
	ENEMY
	redefine
		act,pre_act
	end


create
	make,make_fighter

feature -- Initialization

	make_fighter(locate_row,locate_col,e_id:INTEGER)
			-- Initialization for `Current'.
		do

			points:=3
			create {GOLD} orb.make
			enemy_id:=e_id
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			health:=150
			maxhealth:=150
			armour:=10
			r1:=5
			vision:=10
			row:=locate_row
			col:=locate_col
			enemy_type:="Fighter"
			model:=ma.m
			symbol:="F"
			create enemy_projectiles.make_empty
			create projectile.make ("<", 15,0)
			model.inc_enemy_id
			collision_m:=""
			model.round.enemys.force (current, model.round.enemys.count+1)
			model.set_enemy_spawn (true)
			model.set_enemy_spawn_mes (model.round.print_enemy_spawn_mes (enemy_id, "Fighter", row, col))
			model.set_enemy_spawn_mes (check_collide_from_spawn)
			set_seen_by_starfighter(distance(current,model.starfighter)<=model.starfighter.vision)
			set_can_see_starfighter(distance(current,model.starfighter)<=current.vision)
		end

	pre_act(s:STRING)
	local
		p:PROJECTILE
		enemy_action,enemy_action2:ENEMY_ACTION
	do
		current.set_pre_action (true)
		create p.make_enemy (100)
		CREATE enemy_action.make_empty
		CREATE enemy_action2.make_empty
--		--apply regen
			if(maxhealth-health>=r1) then
				inc_health(r1)
			elseif(maxhealth-health<r1) then
				inc_health(maxhealth-health)
			end
		if(health>0) then
			if(s~"fire") then
				armour:=armour+1
				enemy_action.set_gain_armour (1, current)
				model.set_enemy_pre_action (enemy_action.print_action)
			elseif(s~"pass") then
				current.move_action (row, col-6)
				if(if_onboard and model.starfighter.health>0 and health>0) then
				p.set_id (model.projectile_id)


				--set action of projectile
				enemy_action2.set_state ("fire projectile")
				enemy_action2.set_projectile_id (p.id)
				enemy_action2.set_rc (row, col-1)
				model.set_enemy_pre_action (enemy_action2.print_action)
 				model.add_total_projectile (p)

				p.set_r_c (row, col-1)
				p.set_move (10)
				current.add_projectile (p)
				end
			end
		end
	end

	act(s:STRING)
	local
		p:PROJECTILE
		enemy_action,enemy_action2,enemy_action3:ENEMY_ACTION
	do

		set_pre_action(false)
		create p.make_enemy (100)
		CREATE enemy_action.make_empty
		CREATE enemy_action2.make_empty
		create enemy_action3.make_empty
		if(s/~"pass") then
			
			if(can_see_starfighter=true) then

				current.move_action (row, col-1)
				if(if_onboard and model.starfighter.health>0 and health>0) then
				p.set_id (model.projectile_id)
				p.set_damage(50)
				--set action of projectile
				enemy_action2.set_state ("fire projectile")
				enemy_action2.set_projectile_id (p.id)
				enemy_action2.set_rc (row, col-1)
--				add_enemy_action(enemy_action2)
				model.set_enemy_action (enemy_action2.print_action)
				model.add_total_projectile (p)

				p.set_r_c (row,col-1)
				p.set_move (6)
				current.add_projectile (p)
				end
			else

				current.move_action (row, col-3)
				if(if_onboard and model.starfighter.health>0 and health>0) then

				--create p
				p.set_id (model.projectile_id)
				p.set_damage(20)


				--set action of projectile
				enemy_action2.set_state ("fire projectile")
				enemy_action2.set_projectile_id (p.id)
				enemy_action2.set_rc (row, col-1)
				model.set_enemy_action (enemy_action2.print_action)
--				add_enemy_action(enemy_action2)
				model.add_total_projectile (p)

				p.set_r_c (row, col-1)
				p.set_move (3)
				current.add_projectile (p)
				end
			end
		end
	end

end
