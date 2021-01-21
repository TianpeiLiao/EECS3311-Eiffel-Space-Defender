note
	description: "Summary description for {PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTILE

create
	make,make_copy,make_enemy
feature --attributes
	--< means enemy projectile
	--*means friendly projectile
	id:INTEGER
	row,col,col_before,row_before:INTEGER
	--type: friendly or enemy
	type:STRING
	pattern:STRING
	damage,cost:INTEGER
	move:INTEGER
	model:ETF_MODEL
	ma:ETF_MODEL_ACCESS
	collision:BOOLEAN
	destroyed:BOOLEAN
	star_pattern:STRING
	collision_m:STRING
feature {NONE} -- Initialization
	make_copy(p:PROJECTILE)
		do
			model:=ma.m
			id:=p.id
			type:=p.type
			damage:=p.damage
			pattern:=p.pattern
			create type.make_empty
			star_pattern:=""
			collision_m:=""
		end
	make(p:STRING;d,c:INTEGER)
			-- Initialization for `Current'.
		do
			model:=ma.m
			create type.make_empty
			pattern:=p
			damage:=d
			cost:=c
			star_pattern:=""
			collision_m:=""
		end
	--make enemy projectile, set damage to d
	make_enemy(d:INTEGER)
		do
			model:=ma.m
			type:="<"
			create pattern.make_empty
			damage:=d
			star_pattern:=""
			collision_m:=""
		end
feature
	clean_collide_m
	do
		collision_m:=""
	end
	set_star_patter(s:STRING)
	do
		star_pattern:=s
	end
	set_destroyed(d:BOOLEAN)
	do
		destroyed:=d
	end

	set_collide(t:BOOLEAN)
		DO
			collision:=t
		end

	--set friendly or enemy
	set_type(t:STRING)
		do
			type:=t
		end
	set_r_c(r,c:INTEGER)
		local
			row_b,col_b:INTEGER
		do

			row_b:=row
			col_b:=col
			row:=r
			col:=c


			if(star_pattern~"snipe" and row_b/=0) then
				checkcollide(row,col)
				model.set_friendly_p_action ((create {FRIENDLY_PROJECTILE_ACTION}.make_move (current, row_b, col_b, r, c)).print_p_action)
			end
			--means enemy fire the p
			if(type~"<") then
			current.check_collide_from_enemy (row, col)
			elseif(type~"*") then
				current.collide_from_friendly_p
				model.set_friendly_p_action (collision_m)

			end


			end
	set_id(i:INTEGER)
		do
			id:=i
			model.dec_projectile_id
		end
	set_move(m:INTEGER)
		do
			move:=m
		end
	move_action(desrowa:INTEGER;descola:INTEGER)
		local
			i,desrow,descol,diff_col,diff_row,count:INTEGER
		do
			model:=ma.m
			col_before:=col
			row_before:=row
			desrow:=desrowa
			descol:=descola
			diff_col:=descol-col
			diff_col:=diff_col.abs
			diff_row:=desrow-row
			diff_row:=diff_row.abs
			count:=diff_row+diff_col
--			if(diff_row+diff_col <= model.maxmove_s) then
			if(desrowa-row > 0) then
				from
					i:=1
				until
					i>diff_row or damage<=0
				loop
--					if(collide=false) then

					startr_inc
--					end
					i:=i+1
					if(star_pattern/~"spread top" and star_pattern/~"spread down") then
					checkcollide(row,col)
					end
				end
			elseif(desrowa-row < 0) then
				from
					i:=1
				until
					i>diff_row or damage<=0
				loop

--					if(collide=false) then
					startr_dec
--					end
					i:=i+1
					if(star_pattern/~"spread top" and star_pattern/~"spread down") then
					checkcollide(row,col)
					end
				end

			end --end of if
			if(descola-col > 0) then
				from
					i:=1
				until
					i>diff_col or damage<=0
				loop

--					if(collide=false) then

					startc_inc
--					end
					i:=i+1
					checkcollide(row,col)
				end
			elseif(descola-col < 0) then
				from
					i:=1
				until
					i>diff_col or damage<=0
				loop

					startc_dec
					i:=i+1
					if(if_onboard=true) then
					check_collide_from_e
					checkcollide(row,col)
					end
				end
			end --end of if

			if(type~"<") then
				model.set_enemy_p_actions ((create {ENEMY_PROJECTILE_ACTION}.make("move",current)).print_e_action)
				model.set_enemy_p_actions (collision_m)
			elseif(type~"*") then
				model.set_friendly_p_action ((create {FRIENDLY_PROJECTILE_ACTION}.make_move (current, row_before, col_before, row, col)).print_p_action)
				model.set_friendly_p_action (collision_m)
			end

		end

		--only for enemy projectile
		check_collide_from_enemy(r,c:INTEGER)
		local
			enemy_action:ENEMY_ACTION
			r_d,c_d:INTEGER
		do
			create enemy_action.make_empty
			model:=ma.m
			across
				model.round.enemys is es
			loop
				--IF enemy p collide to enemy from fire,and set action to enemy action
				if(es.row=row and es.col=col and type~"<" and es.health>0) then
					enemy_action.set_projectile_collide (es, r_d, c_d, damage)
					if(es.maxhealth-es.health > 0 and es.maxhealth-es.health>damage) then
						es.inc_health(damage)
					elseif(es.maxhealth-es.health > 0 and es.maxhealth-es.health<=damage) then
						es.inc_health(es.maxhealth-es.health)
					end
					if(damage=100) then
						model.set_enemy_pre_action (enemy_action.print_action)
					else
						model.set_enemy_action (enemy_action.print_action)
					end
					damage:=0
				end
				--if enemy p collide with enemy projectile, set to enemy action
				across es.enemy_projectiles is ps
				loop
					if(ps/=current and ps.row=row and ps.col=col and ps.damage>0) then

						if(damage=100) then
							model.set_enemy_pre_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_enemy_p (ps)).print_e_action)
						else
							model.set_enemy_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_enemy_p (ps)).print_e_action)
						end
						set_damage(ps.damage+damage)
						ps.set_damage(0)

					end
				end
			end



			--case 4: collide with starfighter
						if(model.starfighter.row=row and model.starfighter.col=col and damage>0) then
							if(damage>model.starfighter.armour) then
								model.starfighter.dec_health(damage-model.starfighter.armour)
								if(model.starfighter.health<=0) then
									model.starfighter.set_health (0)
--									model.round.set_skip_from_p1 (true)
								end
							end
							if(damage=100) then
								model.set_enemy_pre_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_starfighter (damage-model.starfighter.armour)).print_e_action)
								if(model.starfighter.health<=0) then
									model.set_enemy_pre_action ((create {ENEMY_ACTION}.starfighter_destroy(row,col)).print_action)
									model.starfighter.set_health (0)
								end
							else
								model.set_enemy_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_starfighter (damage-model.starfighter.armour)).print_e_action)
								if(model.starfighter.health<=0) then
									model.set_enemy_action ((create {ENEMY_ACTION}.starfighter_destroy(row,col)).print_action)
									model.starfighter.set_health (0)
								end
							end

							set_damage(0)

						end
			--if colldie with friendly p
			across
				model.starfighter.starfightr_projectiles is ess
			loop
					--if
					if(ess.row=row and ess.col=col and damage>0 and ess.damage>0) then
						if(damage=100) then
							model.set_enemy_pre_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_friendly_p (ess)).print_e_action)
						else
							model.set_enemy_action((create {ENEMY_PROJECTILE_ACTION}.make_collide_with_friendly_p (ess)).print_e_action)
						end
					if(ess.damage>damage) then
						ess.set_damage(ess.damage-damage)
						damage:=0
					--case 1.2 if the friendly projectile’s damage
					--is higher, the enemy projectile is removed from the board. The new friendly projectile’s damage is its
					--damage subtracted by the enemy projectile’s damage.
					elseif(ess.damage<damage)then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col))
						set_damage(current.damage-ess.damage)
						ess.set_damage(0)
					--case 1.3 if damages of both projectiles are the same, they are both removed from the board.
					elseif(ess.damage=damage)then
						set_damage(0)
						ess.set_damage(0)
					end

					end --end of if	
			end
		end

		throw
		do
			row:=-8
			col:=-8
		end

		checkcollide(modelr,modelc:INTEGER)
		do
			model:=ma.m
			--friendly projectiles
			--case 1 Colliding with an enemy projectile
			if(type~"*" AND if_onboard) then
			across
				model.round.enemys is es
			loop
				across
					es.enemy_projectiles is  ps
				loop
					if(ps/=current and ps.collision=false and damage>0 and ps.damage>0) then
					--case 1.1 enemy projectile’s damage is higher, the friendly projectile is removed from the board.
					--The new enemy projectile’s damage is its damage subtracted by the friendly projectile’s damage.
					if(ps.row=row and ps.col=col) then
					if(ps.damage>damage) then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (ps, current,row,col))

						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action
						ps.set_damage(ps.damage-damage)
						set_damage(0)
					--case 1.2 if the friendly projectile’s damage
					--is higher, the enemy projectile is removed from the board. The new friendly projectile’s damage is its
					--damage subtracted by the enemy projectile’s damage.
					elseif(ps.damage<damage)then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col))
						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action
						set_damage(current.damage-ps.damage)
						ps.set_damage(0)
					--case 1.3 if damages of both projectiles are the same, they are both removed from the board.
					elseif(ps.damage=damage)then
						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action
						ps.set_damage(0)
						set_damage(0)
					end
					end --end of if
					end --end of if(ps/=current)
				end


			end

			--collide with enemy
			across
				model.round.enemys is es
			loop
			--case 3 Colliding with an enemy
				if(es.row=row and es.col=col and es.health>0) then

					if(damage>es.armour) then
						es.dec_health(damage-es.armour)
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make_c_with_enemy (current, es, damage-es.armour))
						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make_c_with_enemy (current, es, damage-es.armour)).print_p_action

						if(es.health<=0) then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make_destroy_enemy (es))
						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make_destroy_enemy (es)).print_p_action
						es.set_r_c(-8,-8)
--						model.starfighter.set_score (model.starfighter.score+es.points)
						end
					end
					set_damage(0)
				end
			end

			--case 2 Colliding with a friendly projectile
			across
				model.starfighter.starfightr_projectiles is ps
			loop
				if(ps/=current and ps.damage>0 and damage>0) then
					if(row=ps.row and col=ps.col) then
						collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make_collide_with_friendly_p (current)).print_p_action
						set_damage(damage+ps.damage)
						ps.set_damage(0)
					end
				end

			end
			--case 4 Colliding with the Starfighter
			if(model.starfighter.row=row and model.starfighter.col=col) then
				if(damage>model.starfighter.armour) then
					collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make_collide_with_starfighter(current,(damage-model.starfighter.armour))).print_p_action
						model.starfighter.dec_health(damage-model.starfighter.armour)
						if(model.starfighter.health<=0) then
--						model.round.set_skip_from_p1 (true)
						end
				else
					collision_m:=collision_m+(create {FRIENDLY_PROJECTILE_ACTION}.make_collide_with_starfighter(current,0)).print_p_action
					end
				set_damage(0)
			end
			end --if(type~"*")
		end
		--for enemy projectile action
		check_collide_from_e
		do
			if(type~"<" and if_onboard) then

				across
				model.round.enemys is es
				loop

				--case 3 Colliding with an enemy
				if(es.row=row and es.col=col and es.health>0) then
					if(es.maxhealth-es.health>=damage and es.maxhealth-es.health > 0) then
							es.inc_health(damage)
					elseif(es.maxhealth-es.health<damage and es.maxhealth-es.health > 0) then
						es.inc_health(es.maxhealth-es.health)
					end
					collision_m:=collision_m+(create {ENEMY_PROJECTILE_ACTION}.make_collide_e ("collide enemy", es, current)).print_e_action
					set_damage(0)
				end

				across
					es.enemy_projectiles is  ps
				loop
					if(ps/=current and ps.damage>0 and damage>0) then
					--case 1. The stationary projectile is removed from the board. The moving
					--enemy projectile’s damage gets added with the damage of the stationary projectile.
							if(ps.row=row and ps.col=col) then
							set_damage(ps.damage+damage)
							collision_m:=collision_m+(create {ENEMY_PROJECTILE_ACTION}.make_collide_with_enemy_p (ps)).print_e_action
							ps.set_damage(0)
							end --end of if
					end --end of if(ps/=current)
				end


				--case 4: collide with starfighter
				if(model.starfighter.row=row and model.starfighter.col=col and damage>0) then
--					model.set_test_m (row.out+col.out)
--					model.set_debug_mode (true)
					if(damage>model.starfighter.armour) then
						model.starfighter.dec_health(damage-model.starfighter.armour)
						if(model.starfighter.health<=0) then
						model.starfighter.set_health (0)
--						model.round.set_skip_from_p1 (true)
						end
					end
					collision_m:=collision_m+(create {ENEMY_PROJECTILE_ACTION}.make_collide_with_starfighter (damage-model.starfighter.armour)).print_e_action

					if(model.starfighter.health<=0) then
						collision_m:=collision_m+(create {ENEMY_ACTION}.starfighter_destroy(row,col)).print_action
						model.starfighter.set_health (0)
					end
					set_damage(0)
				end
				--case 5:collide with starfighter projectiles
				across
				model.starfighter.starfightr_projectiles is ess
				loop
					if(ess.row=row and ess.col=col and damage>0 and ess.damage>0) then

					if(ess.damage>damage) then
						ess.set_damage(ess.damage-damage)
						damage:=0
					--case 1.2 if the friendly projectile’s damage
					--is higher, the enemy projectile is removed from the board. The new friendly projectile’s damage is its
					--damage subtracted by the enemy projectile’s damage.
					elseif(ess.damage<damage)then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col))
						set_damage(current.damage-ess.damage)
						ess.set_damage(0)
					--case 1.3 if damages of both projectiles are the same, they are both removed from the board.
					elseif(ess.damage=damage)then
						set_damage(0)
						ess.set_damage(0)
					end
					collision_m:=collision_m+(create {ENEMY_PROJECTILE_ACTION}.make_collide_with_friendly_p (ess)).print_e_action

					end --end of if
				end
			end

			end
		end


		startr_inc
		do
			row:=row+1
		end

		if_onboard:BOOLEAN
		do
			result:=(row>=1 and row<=model.warzone.row and col>=1 and col<=model.warzone.col)
		end

		startr_dec
		do
			row:=row-1
		end

		startc_inc
		do
			col:=col+1
		end

		startc_dec
		do
			col:=col-1
		end

		set_damage(s:INTEGER)
		do
			damage:=s

		end

		collide_from_friendly_p
		do
			if(type~"*") then

			across
				model.round.enemys is es
			loop
				across
					es.enemy_projectiles is  ps
				loop
					if(ps/=current and ps.collision=false and damage>0 and ps.damage>0) then
					--case 1.1 enemy projectile’s damage is higher, the friendly projectile is removed from the board.
					--The new enemy projectile’s damage is its damage subtracted by the friendly projectile’s damage.
					if(ps.row=row and ps.col=col) then

					if(ps.damage>damage) then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (ps, current,row,col))
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action)
						ps.set_damage(ps.damage-damage)
						set_damage(0)
					--case 1.2 if the friendly projectile’s damage
					--is higher, the enemy projectile is removed from the board. The new friendly projectile’s damage is its
					--damage subtracted by the enemy projectile’s damage.
					elseif(ps.damage<damage)then

--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col))
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action)

						set_damage(current.damage-ps.damage)
						ps.set_damage(0)

					--case 1.3 if damages of both projectiles are the same, they are both removed from the board.
					elseif(ps.damage=damage)then
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make (current, ps,row,col)).print_p_action)
						ps.set_damage(0)
						set_damage(0)
					end
					end --end of if
					end --end of if(ps/=current)
				end
				--case 3 Colliding with an enemy
				if(es.row=row and es.col=col and es.health>0) then
					if(damage>es.armour) then
						es.dec_health(damage-es.armour)
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make_c_with_enemy (current, es, damage-es.armour))
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make_c_with_enemy (current, es, damage-es.armour)).print_p_action)
						if(es.health<=0) then
--						model.starfighter.add_f_p_action (create {FRIENDLY_PROJECTILE_ACTION}.make_destroy_enemy (es))
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make_destroy_enemy (es)).print_p_action)
						es.set_r_c(-8,-8)
--						model.starfighter.set_score (model.starfighter.score+es.points)
						end
					end
					set_damage(0)

				end
			end

			--case 2 Colliding with a friendly projectile
			across
				model.starfighter.starfightr_projectiles is ps
			loop
				if(ps.id/=id and ps.damage>0) then
					if(row=ps.row and col=ps.col) then
						model.starfighter.add_s_collide((create {FRIENDLY_PROJECTILE_ACTION}.make_collide_with_friendly_p (ps)).print_p_action)
						set_damage(damage+ps.damage)
						ps.set_damage(0)
					end
				end

			end

			end --if(type~"*")
		end
end
