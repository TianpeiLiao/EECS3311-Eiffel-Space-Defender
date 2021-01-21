note
	description: "Summary description for {PYLON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYLON
inherit
	ENEMY
	redefine
		act
	end


create
	make,make_pylon

feature -- Initialization

	make_pylon(locate_row,locate_col,e_id:INTEGER)
			-- Initialization for `Current'.
		do
			create {PLATINUM_FOCUS} orb.make
			orb.add_orb (create {BRONZE}.make)
			points:=4
			enemy_id:=e_id
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			health:=300
			maxhealth:=300
			armour:=0
			r1:=0
			vision:=5
			row:=locate_row
			col:=locate_col
			enemy_type:="Pylon"
			model:=ma.m
			symbol:="P"
			create enemy_projectiles.make_empty
			create projectile.make ("<", 15,0)
			model.inc_enemy_id
			collision_m:=""
			model.round.enemys.force (current, model.round.enemys.count+1)
			model.set_enemy_spawn (true)
			model.set_enemy_spawn_mes (model.round.print_enemy_spawn_mes (enemy_id, "Pylon", row, col))
			model.set_enemy_spawn_mes (check_collide_from_spawn)
			set_seen_by_starfighter(distance(current,model.starfighter)<=model.starfighter.vision)
				set_can_see_starfighter(distance(current,model.starfighter)<=current.vision)
		end

	act(s:STRING)
	local
		p:PROJECTILE
		enemy_action,enemy_action2,enemy_action3:ENEMY_ACTION
		enemy:ENEMY
	do

		set_pre_action(false)
		model:=ma.m
		create p.make_enemy (100)
		CREATE enemy_action.make_empty
		CREATE enemy_action2.make_empty
		CREATE enemy_action3.make_empty
			if(can_see_starfighter=true) then
				current.move_action (row, col-1)
				if(if_onboard and health>0 and model.starfighter.health>0) then
				p.set_id (model.projectile_id)
				p.set_damage(70)

				--set action of projectile
				enemy_action2.set_state ("fire projectile")
				enemy_action2.set_projectile_id (p.id)
				enemy_action2.set_rc (row, col-1)
				model.set_enemy_action (enemy_action2.print_action)
				p.set_r_c (row, col-1)
				p.set_move (2)
				current.add_projectile (p)
				model.add_total_projectile (p)
				end
			else
				--move left 2
				current.move_action (row, col-2)
				if(if_onboard and health>0 and model.starfighter.health>0) then
				--heal enemy with vision 10
				across
					model.round.enemys is es
				loop
					if(model.round.distance (current, es)<=vision and es.if_onboard=true and es.health>0) then
						if(es.maxhealth-es.health>0 and es.maxhealth-es.health>10) then
							es.inc_health(10)
						elseif(es.maxhealth-es.health>0 and es.maxhealth-es.health<=10) then
							es.inc_health(es.maxhealth-es.health)
						end
						CREATE enemy_action3.make_empty
						enemy_action3.set_heal_enemy (es)
						model.set_enemy_action (enemy_action3.print_action)
					end
				end
				end

			end
	end

end
