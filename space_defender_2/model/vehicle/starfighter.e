note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER
inherit
	VEHICLE
	redefine
		make
	end
create
	make
feature --attributes
	starfightr_projectiles:ARRAY[PROJECTILE]
	score:INTEGER
	spawn_row,spawn_col:INTEGER
	destinate_row,destinate_col:INTEGER
	starfighter_collisions:ARRAY[F_COLLISION]
	fire_m,destroy_m:STRING
	starfighter_coll_mess,power_later_m:STRING
	overcharge_m:STRING
	if_print_output_action:BOOLEAN
	orbs:ARRAY[ORB]
feature --commands
	get_score:INTEGER
	do
		result:=0;
		across
			orbs is ob
		loop
			result:=result+ob.get_points
		end
	end
	add_orb(o:ORB)
	do


		if(orbs.count=0) then
			orbs.force (o, orbs.count+1)
		elseif attached orbs.at (orbs.count) as ob then

			if((ob.name~"diamond" or ob.name~"platinum") and ob.array.count<ob.max_size) then
				orbs.at (orbs.count).add_orb (o)
				
			else

				orbs.force (o, orbs.count+1)

			end
		end
	end
	set_if_print_actionoutpu(b:BOOLEAN)
	do
		if_print_output_action:=b
	end
	set_overcharge_m(s:STRING)
	do
		overcharge_m:=s
	end
	clea_p
	do
		create starfightr_projectiles.make_empty
	end
	make(locate_row,locate_col,po:INTEGER;p_t:STRING;p_d,p_c:INTEGER)
		do
			overcharge_m:=""
			power_later_m:=""
			starfighter_coll_mess:=""
			create starfighter_collisions.make_empty
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			row:=locate_row
			col:=locate_col
			power:=po
			model:=ma.m
			create projectile.make (p_t, p_d, p_c)
			create starfightr_projectiles.make_empty
			fire_m:=""
			destroy_m:=""
			create orbs.make_empty
		end
	set_fire_m(i,r,c:INTEGER;p:PROJECTILE)
	DO
		if(r>0 and r<=model.warzone.row and c>0 and c<=model.warzone.col) then
		fire_m:=fire_m+"      A friendly projectile(id:" +i.out+") spawns at location [" + alphabit.at (r)+"," + c.out+"].%N"
		fire_m:=fire_m+starfighter_coll_mess
		else
		fire_m:=fire_m+"      A friendly projectile(id:" +i.out+") spawns at location out of board.%N"

		p.set_damage(0)
		end
	end

	teleport(desrowa,descola:INTEGER)
		do
			col_before:=col
			row_before:=row
			row:=desrowa
			col:=descola
			checkcollide(row,col)
		end

	set_des_rc(r,c:INTEGER)
		do
			destinate_row:=r
			destinate_col:=c
		end

	set_spawn_rc(r,c:INTEGER)
		do
			spawn_row:=r
			spawn_col:=c
		end

	load_p(p:PROJECTILE;r,c:INTEGER)
		do
			p.set_id (model.projectile_id)
			p.set_damage (70)
			p.set_type ("*")
			p.set_r_c (r, c+1)

			p.set_move(5)
			model.add_total_projectile (p)
			starfightr_projectiles.force (p, starfightr_projectiles.count+1)
			set_fire_m(p.id,r,c+1,p)
		end
	fire
		local
			p1,p2,p3:PROJECTILE
		do
			fire_m:=""
			create p1.make_copy(projectile)
			create p2.make_copy(projectile)
			create p3.make_copy(projectile)
			check attached {WEAPON_STATE} model.states_setup.at (2) as w_s then
				if(w_s.arrays.at(w_s.selected_index).type~"Standard") then
					current.load_p(p1,row,col)
				elseif(w_s.arrays.at(w_s.selected_index).type~"Spread") then
					load_shotgun(p1,p2,p3)
				elseif(w_s.arrays.at(w_s.selected_index).type~"Snipe") then
					load_snipe(p1)
				elseif(w_s.arrays.at(w_s.selected_index).type~"Rocket") then
					load_rocket(p1,p2)
				elseif(w_s.arrays.at(w_s.selected_index).type~"Splitter") then
					load_splitter(p1)
				end
			end
		end
feature --queries
	load_splitter(p1:PROJECTILE)
	do
		p1.set_id (model.projectile_id)
		p1.set_damage (150)
		p1.set_type ("*")
		p1.set_r_c (row, col+1)

		p1.set_move(0)
		model.add_total_projectile (p1)
		starfightr_projectiles.force (p1, starfightr_projectiles.count+1)
		p1.set_star_patter ("splitter")
		set_fire_m(p1.id,row,col+1,p1)
	end
	load_rocket(p1,p3:PROJECTILE)
	do
		--top left

		p1.set_id (model.projectile_id)
		p1.set_damage (100)
		p1.set_type ("*")
		p1.set_r_c (row-1, col-1)
		p1.set_move(1)
		model.add_total_projectile (p1)
		starfightr_projectiles.force (p1, starfightr_projectiles.count+1)
		p1.set_star_patter ("rocket")
		set_fire_m(p1.id,row-1,col-1,p1)

		--right left
		p3.set_id (model.projectile_id)
		p3.set_damage (100)
		p3.set_type ("*")
		p3.set_r_c (row+1, col-1)
		p3.set_move(1)
		p3.set_star_patter ("rocket")
		model.add_total_projectile (p3)
		starfightr_projectiles.force (p3, starfightr_projectiles.count+1)
		set_fire_m(p3.id,row+1,col-1,p3)
	end

	load_snipe(p:PROJECTILE)
	do
		p.set_id (model.projectile_id)
		p.set_type ("*")

		p.set_move(8)
		p.set_star_patter("snipe")
		p.set_damage (1000)
		p.set_r_c (row, col+1)
		model.add_total_projectile (p)
		starfightr_projectiles.force (p, starfightr_projectiles.count+1)
		set_fire_m(p.id,row,col+1,p)
	end
	load_shotgun(p1,p2,p3:PROJECTILE)
	do
		--set p1 top right

		p1.set_id (model.projectile_id)
		p1.set_damage (50)
		p1.set_type ("*")
		p1.set_r_c (row-1, col+1)

		p1.set_move(1)
		model.add_total_projectile (p1)
		starfightr_projectiles.force (p1, starfightr_projectiles.count+1)
		p1.set_star_patter ("spread top")
		set_fire_m(p1.id,row-1,col+1,p1)

		-- p2 right
		p2.set_id (model.projectile_id)
		p2.set_damage (50)
		p2.set_type ("*")
		p2.set_r_c (row, col+1)
		p2.set_move(1)
		model.add_total_projectile (p2)
		starfightr_projectiles.force (p2, starfightr_projectiles.count+1)
		set_fire_m(p2.id,row,col+1,p2)

		--p3 down right
		p3.set_id (model.projectile_id)
		p3.set_damage (50)
		p3.set_type ("*")
		p3.set_r_c (row+1, col+1)

		p3.set_move(1)
		p3.set_star_patter ("spread down")
		model.add_total_projectile (p3)
		starfightr_projectiles.force (p3, starfightr_projectiles.count+1)
		set_fire_m(p3.id,row+1,col+1,p3)

	end

	set(ty:TYPE_SETUP)
		do
			r1:=r1+ty.return_r1
			r2:=r2+ty.return_r2
			maxhealth:=maxhealth+ty.return_health
			health:=maxhealth
			maxenergy:=maxenergy+ty.return_energy
			energy:=maxenergy
			armour:=armour+ty.return_armour
			vision:=vision+ty.return_vision
			move:=move+ty.return_move
			move_cost:=move_cost+ty.return_movecost
		end

	output:STRING
	do
		result:=""
		check attached {WEAPON_STATE} model.states_setup.at (2) as ww_s then
			--if selected rocket, every time fire cost health
			if(ww_s.arrays.at(ww_s.selected_index).type~"Rocket") then
			result:="  Starfighter:%N"
            result:=result+"    [0"+",S]->health:"+current.health.out+"/"+maxhealth.out+", energy:"+energy.out+"/"+
            maxenergy.out+", Regen:"+r1.out+"/"+r2.out+", Armour:"+armour.out+", Vision:"+vision.out+", Move:"+move.out+", Move Cost:"+
            move_cost.out+", location:["+alphabit.at (row)+","+col.out+"]%N"+

      		"      Projectile Pattern:"+projectile.pattern+", Projectile Damage:"+projectile.damage.out+", Projectile Cost:"+projectile.cost.out+ " (health)%N"
			check attached {POWER_STATE} model.states_setup.at (5) as w_s then
				result:=result+"      Power:"+w_s.powers.at (w_s.selected_index).type_power+"%N"
			end
      		result:=result+"      score:"+get_score.out

      		--else
      		else
      			result:="  Starfighter:%N"
            result:=result+"    [0"+",S]->health:"+current.health.out+"/"+maxhealth.out+", energy:"+energy.out+"/"+
            maxenergy.out+", Regen:"+r1.out+"/"+r2.out+", Armour:"+armour.out+", Vision:"+vision.out+", Move:"+move.out+", Move Cost:"+
            move_cost.out+", location:["+alphabit.at (row)+","+col.out+"]%N"+

      		"      Projectile Pattern:"+projectile.pattern+", Projectile Damage:"+projectile.damage.out+", Projectile Cost:"+projectile.cost.out+ " (energy)%N"
			check attached {POWER_STATE} model.states_setup.at (5) as w_s then
				result:=result+"      Power:"+w_s.powers.at (w_s.selected_index).type_power+"%N"
			end
      		result:=result+"      score:"+get_score.out

      		end
      		end
	end



	output_action:STRING
	do
		result:=""
		if(model.round.action.state~"pass") then
			result:="    The Starfighter(id:0"+") passes at location ["+alphabit.at (row)+","+col.out+"], doubling regen rate.%N"
		elseif(model.round.action.state~"move") then
				result:="    The Starfighter(id:0" +") moves: ["+alphabit.at (row_before)+","+col_before.out+"] -> ["+alphabit.at(row)+","+col.out+"]%N"
				result:=result+output_collide_actions
		elseif(model.round.action.state~"fire") then
			result:="    The Starfighter(id:0" +") fires at location ["+alphabit.at (row)+","+col.out+"].%N"
			result:=result+fire_m
--			result:=result+starfighter_coll_mess
		elseif(model.round.action.state~"special") then
		check attached {POWER_STATE} model.states_setup.at (5) as w_s then
			if(w_s.powers.at(w_s.selected_index).type~"recall") then
				result:="    The Starfighter(id:0" + ") uses special, teleporting to: ["+alphabit.at (row)+","+col.out+"]%N"
				result:=result+output_collide_actions
			elseif(w_s.powers.at(w_s.selected_index).type~"repair") then
				result:="    The Starfighter(id:0) uses special, gaining 50 health.%N"
			elseif(w_s.powers.at(w_s.selected_index).type~"deploy") then
				result:="    The Starfighter(id:0) uses special, clearing projectiles with drones.%N"
				result:=result+power_later_m
			elseif(w_s.powers.at(w_s.selected_index).type~"overcharge") then
				result:=overcharge_m

			elseif(w_s.powers.at(w_s.selected_index).type~"orbital") then
				result:="    The Starfighter(id:0) uses special, unleashing a wave of energy.%N"
				result:=result+power_later_m
			end
		end
		end
	end

	set_power_later_m(s:STRING)
	DO
		power_later_m:=power_later_m+s
	end
	clean_power_later_m
	do
		power_later_m:=""
	end

	output_collide_actions:STRING
	do
		result:=""
		result:=starfighter_coll_mess
		across
			current.starfighter_collisions is cs
		loop
			result:=result+cs.print_c
		end
		result:=result+destroy_m

--		across
--			model.round.enemys is es
--		loop
--			if(es.health<=0 and es.row>0 and es.row<=model.warzone.row) then
--				result:=result+"      The " + es.enemy_type + " at location [" + model.alphabit.at (es.row)+","+es.col.out+"] has been destroyed.%N"
--			end
--		end
--		if(health<=0 and row>0 and row<=model.warzone.row) then
--			result:=result+"      The Starfighter at location [" + model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
--		end
		end

	checkcollide(r,c:INTEGER)
		local
			collision:F_COLLISION
		do
			model:=ma.m
			--check if collide with enemy projectiles
			across
				model.round.enemys is es
			loop
				--check if collide with enemy
				if(es.row=row and es.col=col and es.health>0) then
					dec_health(es.health)
					add_s_collide((create {F_COLLISION}.make_e_c (row, col, es,"s")).print_c)
					add_orb(es.orb)
					destroy_m:=destroy_m+"      The " + es.enemy_type + " at location [" + model.alphabit.at (es.row)+","+es.col.out+"] has been destroyed.%N"
					if(health<=0) then
						destroy_m:=destroy_m+"      The Starfighter at location [" + model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
					end
				end
				--loop es.projectiles, check if collide with projectiles
				across
				es.enemy_projectiles is  ps
				loop
					if(ps.row=model.starfighter.row and ps.col=model.starfighter.col and ps.damage>0) then

						add_s_collide((create {F_COLLISION}.make_p_c (row, col, ps,"s")).print_c)
						dec_health(ps.damage-armour)
						if(model.starfighter.health<=0) then
							destroy_m:=destroy_m+"      The Starfighter at location [" + model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
						end
						ps.set_damage(0)
					end

				end --end of inner loop
			end  --end of outer loop

			across
				starfightr_projectiles is ps
			loop
				if(ps.row=model.starfighter.row and ps.col=model.starfighter.col and ps.damage>0) then
						add_s_collide((create {F_COLLISION}.make_friendly_p_collision (ps.row, ps.col,ps,"")).print_c)
						health:=health-(ps.damage-armour)
						if(model.starfighter.health<=0) then
							health:=0
							destroy_m:=destroy_m+"      The Starfighter at location [" + model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
						end
						ps.set_damage(0)
					end
			end

		end

	add_s_collide(c:STRING)
	do
		starfighter_coll_mess:=starfighter_coll_mess+c
	end

	reset_s_colldie
	do
		starfighter_coll_mess:=""
	end
--	set_score(s:INTEGER)
--	do
--		score:=score+s
--	end

end
