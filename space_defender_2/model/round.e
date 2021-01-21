note
	description: "Summary description for {ROUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROUND

create
	make

feature
	action:ACTION
	model:ETF_MODEL
	enemy_turn,random_enemy_type,random_enemy_location:INTEGER
	ma:ETF_MODEL_ACCESS
	enemys:ARRAY[ENEMY]
	alphabit:ARRAY[STRING]
	skip_from_p1:BOOLEAN
	random:RANDOM_GENERATOR_ACCESS
feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create action.make
			model:=ma.m
			create enemys.make_empty
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
		end
feature --commands
	clean_enemys
	do
		create enemys.make_empty
	end


	set_random_enemy_type
	do
		random_enemy_type:=random.rchoose (1, 100)
	end

	set_random_enemy_location
	do
		random_enemy_location:=random.rchoose (1, model.warzone.row)
	end
	change_action(a:ACTION)
	do
		action:=a
	end

	set_action(a:ACTION)
	local
		enemy:ENEMY
	do
		model:=ma.m
		model.reset_toggle
		model.set_game_start (true)
		model.starfighter.set_if_print_actionoutpu (true)
		--clean war zone
		across
			enemys is es
		loop
			if(es.health<0) then
				es.set_r_c(-8,-8)
			end
		end
		
		--phase 1:friendly projectiles act
		model.clean_friendly_p_action

		if(model.starfighter.health>0) then
			across
				model.starfighter.starfightr_projectiles is ps
			loop
				if(ps.damage>0) then
					ps.clean_collide_m
					if(ps.pattern~"Standard" and ps.destroyed=false) then
					ps.move_action(ps.row,ps.col+5)
					elseif(ps.pattern~"Spread" and ps.star_pattern~"") then
						ps.move_action(ps.row,ps.col+1)
					elseif(ps.star_pattern~"spread top") then
						ps.move_action(ps.row-1,ps.col+1)
					elseif(ps.star_pattern~"spread down") then
						ps.move_action(ps.row+1,ps.col+1)
					elseif(ps.star_pattern~"snipe") then
						ps.set_r_c(ps.row,ps.col+8)


					elseif(ps.star_pattern~"rocket") then
						ps.move_action(ps.row,ps.col+ps.move)
						ps.set_move(ps.move*2)
					elseif(ps.star_pattern~"splitter") then
						model.set_friendly_p_action ("    A friendly projectile(id:"+ps.id.out+") stays at: [" +model.alphabit.at (ps.row)+","+ps.col.out+"]%N")
					end
				end
			end
		end
		model.clean_e_p_actions
		action:=a

		--phase2:enemy projectiles act
		if(model.starfighter.health>0) then
			across
				model.total_projectiles is ps
			loop
				ps.clean_collide_m
				if(ps.row>=1 and ps.row<=model.warzone.row and ps.collision=false and ps.type~"<" and ps.damage>0 and model.starfighter.health>0) then
					ps.move_action(ps.row,ps.col-ps.move)
				end
			end
		end

		if(model.starfighter.health<=0) then
			model.starfighter.set_if_print_actionoutpu (false)
		end
		--phase 3:starfighter act
		if(model.starfighter.health>0) then
			starfighter_act
		end
		--phase4:enemy vision update


		--phase5:enemies act
		model.clean_enemy_pre_action
		model.clean_enemy_action
		if(model.starfighter.health>0) then
			enemy_act
			--reset_just_createdby
			across
				enemys is es
			loop
				es.set_just_created_by_c(false)
			end

		end

		--phase 6 enemy vision update

		if(model.starfighter.health>0) then

		across
			enemys is es
		loop
			if(es.health>0) then
				es.set_seen_by_starfighter(distance(es,model.starfighter)<=model.starfighter.vision)
--				model.set_test_m (distance(es,model.starfighter).out +" " )
				es.set_can_see_starfighter(distance(es,model.starfighter)<=es.vision)
		    end
		end
		end
		model.reset_enemy_spawn_mes
		if(model.starfighter.health>0) then
		--phase 7:enermy spawn
			current.set_random_enemy_location
			current.set_random_enemy_type

			if(model.p.g_threshold>1 and random_enemy_type>=1 and random_enemy_type<model.p.g_threshold ) then
			--create grunt
				if(if_occupied_by_enemy (random_enemy_location)=false) then
					create {GRUNT} enemy.make_grunt(random_enemy_location, model.warzone.col,model.enemy_id)
				end
			elseif(random_enemy_type>= model.p.g_threshold and random_enemy_type<model.p.f_threshold ) then
			--create fighter
				if(if_occupied_by_enemy (random_enemy_location)=false) then
					create {FIGHTER} enemy.make_fighter(random_enemy_location, model.warzone.col,model.enemy_id)
				end
			elseif(random_enemy_type>= model.p.f_threshold and random_enemy_type<model.p.c_threshold ) then
			--create carrier
				if(if_occupied_by_enemy (random_enemy_location)=false) then
					create {CARRIER} enemy.make_carrier(random_enemy_location, model.warzone.col,model.enemy_id)
				end
			elseif(random_enemy_type>= model.p.c_threshold and random_enemy_type<model.p.i_threshold ) then
			--create interceptor
				if(if_occupied_by_enemy (random_enemy_location)=false) then
					create {INTERCEPTOR} enemy.make_interceptor(random_enemy_location, model.warzone.col,model.enemy_id,false)
				end
			elseif(random_enemy_type>= model.p.i_threshold and random_enemy_type<model.p.p_threshold ) then
			--create pylon
				if(if_occupied_by_enemy (random_enemy_location)=false) then
					create {PYLON} enemy.make_pylon(random_enemy_location, model.warzone.col,model.enemy_id)
				end
			end
		end


	end

	enemy_act
	do
		across
			enemys is es
		loop

			if(es.health>0 and es.if_onboard=true and model.starfighter.health>0) then
			es.pre_act(action.state)
			end
		end --end of loop
		across
			enemys is es
		loop
			if(es.health>0 and es.if_onboard=true and model.starfighter.health>0) then
			es.act(action.state)
			end
		end
	end

	print_enemy:STRING
	do
		model:=ma.m
		result:=""
		across
			enemys is es
		loop
			if(es.health>0) then
				IF(model.starfighter.health>0) then
				es.set_seen_by_starfighter(distance(es,model.starfighter)<=model.starfighter.vision)
				es.set_can_see_starfighter(distance(es,model.starfighter)<=es.vision)
				end
				if(es.row>=1 and es.row<=model.warzone.row and es.col>=1 and es.col<=model.warzone.col) then
				result:=result+"    ["+es.enemy_id.out+ ","+es.symbol+"]->health:"+es.health.out+"/"+es.maxhealth.out+", Regen:"+es.r1.out+", Armour:"+es.armour.out+", Vision:"+es.vision.out
				+", seen_by_Starfighter:"+es.print_tf(es.seen_by_Starfighter)+", can_see_Starfighter:"+es.print_tf(es.can_see_Starfighter)+", location:["+alphabit.at (es.row)+","+es.col.out+"]"+
				"%N";
			    end
		    end
		end

	end

	print_enemy_spawn_mes(id:INTEGER;t:STRING;row,col:INTEGER):STRING
		do
			model:=ma.m
			result:=""
			if(model.enemy_spawn=true and row>0 and row<=model.warzone.row and col>0 and col<=model.warzone.col) then
			result:="%N    A " + t + "(id:" + id.out+") spawns at location [" + alphabit.at (row)+","+col.out+"]."

			end
		end

	distance(e:VEHICLE;s:VEHICLE):INTEGER
		local
			diff_row,diff_col:INTEGER
		do
			model:=ma.m
			diff_row := e.row-s.row
			diff_col:=e.col-s.col
			diff_row:=diff_row.abs
			diff_col:=diff_col.abs
			result:=diff_row+diff_col
		end

	if_occupied_by_enemy(r:INTEGER):BOOLEAN
	do
		result:=false
		model:=ma.m
		across
			model.round.enemys is es
		loop
			if(es.col=model.warzone.col and es.row=r and es.health>0) then
				result:=true
			end
		end
	end


	starfighter_act
	do
		model:=ma.m
		model.starfighter.reset_s_colldie
		--phase 3
		if(action.state~"pass") then
			model.starfighter.regen
			model.starfighter.regen
		elseif(action.state~"move") then
			model.starfighter.regen
			model.starfighter.move_action(model.starfighter.destinate_row, model.starfighter.destinate_col)
		elseif(action.state~"fire") then
			check attached {WEAPON_STATE} model.states_setup.at (2) as ww_s then
			if(ww_s.arrays.at(ww_s.selected_index).type~"Rocket") then
			model.starfighter.regen
			model.starfighter.set_health((model.starfighter.health-model.starfighter.projectile.cost))
			model.starfighter.fire
			else
			model.starfighter.regen
			model.starfighter.dec_energyby (model.starfighter.projectile.cost)
			model.starfighter.fire
			end
			end
		elseif(action.state~"special") then
			model.starfighter.regen
			model.starfighter.clean_power_later_m
			check attached {POWER_STATE} model.states_setup.at (5) as w_s then
				if(w_s.powers.at(w_s.selected_index).type~"recall") then
					model.starfighter.dec_energyby (w_s.powers.at(w_s.selected_index).amount)
					model.starfighter.teleport (model.starfighter.spawn_row, model.starfighter.spawn_col)
				elseif(w_s.powers.at(w_s.selected_index).type~"repair") then
					model.starfighter.dec_energyby (w_s.powers.at(w_s.selected_index).amount)
					model.starfighter.inc_health (50)
				elseif(w_s.powers.at(w_s.selected_index).type~"deploy") then
					across
						model.total_projectiles is ps
					loop
						if(ps.damage>0) then
						ps.set_damage(0)
						model.starfighter.set_power_later_m ("      A projectile(id:"+ps.id.out+") at location ["+model.alphabit.at (ps.row)+
						","+ps.col.out+"] has been neutralized.%N")
						end
					end
					model.starfighter.dec_energyby (w_s.powers.at(w_s.selected_index).amount)
				elseif(w_s.powers.at(w_s.selected_index).type~"overcharge") then
					if(model.starfighter.health>=51) then
						model.starfighter.inc_energyby (100)
						model.starfighter.set_health (model.starfighter.health-50)
						model.starfighter.set_overcharge_m ("    The Starfighter(id:0) uses special, gaining 100 energy at the expense of 50 health.%N")
					elseif(model.starfighter.health<51 and model.starfighter.health>0) then
						model.starfighter.set_overcharge_m ("    The Starfighter(id:0) uses special, gaining "+((model.starfighter.health-1)*2).out+" energy at the expense of "+(model.starfighter.health-1).out+" health.%N")
						model.starfighter.inc_energyby (((model.starfighter.health-1)*2))
						model.starfighter.set_health (1)
					end
--					model.starfighter.dec_energyby (w_s.powers.at(w_s.selected_index).amount)
				elseif(w_s.powers.at(w_s.selected_index).type~"orbital") then
					across
						enemys is es
					loop
						if(es.health>0 and es.if_onboard) then
						model.starfighter.set_power_later_m ("      A "+es.enemy_type+"(id:"+es.enemy_id.out+") at location ["+model.alphabit.at (es.row)+
						","+es.col.out+"] takes "+(100-es.armour).out+" damage.%N")
						es.set_health((es.health-(100-es.armour)))
							if(es.health<=0 and es.if_onboard) then
								model.starfighter.set_power_later_m ("      The "+es.enemy_type+" at location ["+model.alphabit.at (es.row)+
								","+es.col.out+"] has been destroyed.%N")
								es.set_health((es.health-(100-es.armour)))
								model.starfighter.add_orb (es.orb)
							end
						end


					end
					model.starfighter.dec_energyby (w_s.powers.at(w_s.selected_index).amount)
				end
			end --end of check
		end
		if(model.starfighter.health>0) then
			across
				enemys is es
			loop
				if(es.health>0) then
				es.set_seen_by_starfighter(distance(es,model.starfighter)<=model.starfighter.vision)
				es.set_can_see_starfighter(distance(es,model.starfighter)<=es.vision)
				end
			end
		end

	end
end
