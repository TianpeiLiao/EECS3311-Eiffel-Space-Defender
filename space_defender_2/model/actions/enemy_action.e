note
	description: "Summary description for {ENEMY_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_ACTION

create
	make_empty,collide_with_starfighter,starfighter_destroy,starfighter_destroy_from_enemy_spawn
feature
	state:STRING
	gain_health,id,projectile_id:INTEGER
	ma:ETF_MODEL_ACCESS
	model:ETF_MODEL
	col_before,row_before,row,col,damage:INTEGER
	enemy:ENEMY
	armour,r1:INTEGER
feature {NONE} -- Initialization

	make_empty
			-- Initialization for `Current'.
		do
			model:=ma.m
			create state.make_empty
			create enemy.make (0, 0, 0, "", 0, 0)
		end
feature
	collide_with_starfighter(e:ENEMY)
	do
		enemy:=e
		state:="collide with starfighter"
		model:=ma.m
	end
	set_enemy(e:ENEMY)
	DO
		enemy:=e
	end

	set_enemy_deep_twin(e:ENEMY)
	DO
		enemy:=e.deep_twin
	end

	set_projectile_id(i:INTEGER)
	do
		projectile_id:=i
	end
	set_state(t:STRING)
	do
		state:=t
	end
	set_gain_health(h:INTEGER)
	do
		gain_health:=h
	end
	set_before_rc(r,c:INTEGER)
	do
		row_before:=r
		col_before:=c
	end

	set_state_gain(g_h:INTEGER;e:ENEMY)
	do
		state:="gain"
		gain_health:=g_h
		enemy:=e
	end

	set_gain_r1(r:INTEGER;e:ENEMY)
	do
		state:="gain r1"
		r1:=r
		enemy:=e
	end

	set_gain_armour(a:INTEGER;e:ENEMY)
	do
		state:="gain armour"
		enemy:=e
		armour:=a
	end

	set_rc(r,c:INTEGER)
	do
		row:=r
		col:=c
	end

	set_heal_enemy(e:ENEMY)
	do
		state:="heal enemy"
		enemy:=e
		row:=e.deep_twin.row
		col:=e.deep_twin.col
	end

	set_collide_with_friendly_p(p_id,d:INTEGER;e:ENEMY)
	do
		state:="collide with friendly"
		projectile_id:=p_id
		damage:=d
		enemy:=e.deep_twin
	end

	set_collide_with_friendly_p_fromespawn(p_id,d:INTEGER;e:ENEMY)
	do
		state:="collide with friendly from espawn"
		projectile_id:=p_id
		damage:=d
		enemy:=e.deep_twin
	end


	set_collide_with_enemy_p(p_id,d:INTEGER;e:ENEMY)
	do
		state:="collide with enemy p"
		projectile_id:=p_id
		damage:=d
		enemy:=e.deep_twin
	end

	set_collide_with_enemy_p_from_espawn(p_id,d:INTEGER;e:ENEMY)
	do
		state:="collide with enemy p from espawn"
		projectile_id:=p_id
		damage:=d
		enemy:=e.deep_twin
	end

	set_projectile_collide(e:ENEMY;r,c,d:INTEGER)
	do
		state:="e projectile collide"
		row:=r
		col:=c
		enemy:=e
		damage:=d
	end

	set_destroy(e:ENEMY;r,c:INTEGER)
	do
		state:="destroyed"
		enemy:=e
		row:=r
		col:=c
		model.starfighter.add_orb (e.orb)
--		model.starfighter.set_score(enemy.points)
	end

	set_destroy_from_e_spawn(e:ENEMY;r,c:INTEGER)
	do
		state:="destroyed from e_spawn"
		enemy:=e
		row:=r
		col:=c
		model.starfighter.add_orb (e.orb)
--		model.starfighter.set_score(enemy.points)
	end

	starfighter_destroy(r,c:INTEGER)
	do
		model:=ma.m
		row:=r
		col:=c
		state:="starfighter destroy"
		model.starfighter.set_health(0)

		create enemy.make (0, 0, 0, "", 0, 0)
	end

	starfighter_destroy_from_enemy_spawn(r,c:INTEGER)
	do
		model:=ma.m
		row:=r
		col:=c
		state:="starfighter destroy from e_spawn"
		model.starfighter.set_health(0)
		create enemy.make (0, 0, 0, "", 0, 0)
	end
feature
	print_action:STRING
	DO
		result:=""
		if(state~"gain" and enemy.health>0) then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") "+"gains " + gain_health.out+" total health.%N"
		elseif(state~"moves") then
			if((row/=row_before or col/=col_before) and row>=1 and row<=model.warzone.row and col>=1 and col<=model.warzone.col and row_before>=1 and row_before<=model.warzone.row and col_before>=1 and col_before<=model.warzone.col) then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") "+"moves: " + "["+model.alphabit.at (row_before)+","+col_before.out+"] -> [" + model.alphabit.at (row)+","+col.out+"]%N"
			elseif(row_before>=1 and row_before<=model.warzone.row and col_before>=1 and col_before<=model.warzone.col and (row>model.warzone.row or row<=0 or col>model.warzone.col or col<=0)) then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") "+"moves: " + "["+model.alphabit.at (row_before)+","+col_before.out+"] -> out of board%N"
			enemy.set_health(0)
			elseif((row=row_before and col=col_before) and row>=1 and row<=model.warzone.row and col>=1 and col<=model.warzone.col and row_before>=1 and row_before<=model.warzone.row and col_before>=1 and col_before<=model.warzone.col) then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") "+"stays at: " + "["+model.alphabit.at (row_before)+","+col_before.out+"]%N"
			end
		elseif(state~"fire projectile") then
			IF(row>0 and row<=model.warzone.row and col>0 and col<=model.warzone.col) then
				result:="      A enemy projectile(id:"+projectile_id.out+") spawns at location [" + model.alphabit.at (row) + "," + col.out+"].%N"
			else
				result:="      A enemy projectile(id:"+projectile_id.out+") spawns at location "+"out of board.%N"
			end
		elseif(state~"collide with friendly" and enemy.row>0 and enemy.row<=model.warzone.row) then
			result:="      The "+enemy.enemy_type+" collides with friendly projectile(id:"+projectile_id.out+") at location ["+model.alphabit.at(enemy.row)+
			","+enemy.col.out+"], taking "+damage.out+" damage.%N"
		elseif(state~"collide with friendly from espawn" and enemy.row>0 and enemy.row<=model.warzone.row) then
			result:="      The "+enemy.enemy_type+" collides with friendly projectile(id:"+projectile_id.out+") at location ["+model.alphabit.at(enemy.row)+
			","+enemy.col.out+"], taking "+damage.out+" damage."
		elseif(state~"gain armour") then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") gains "+armour.out + " armour.%N"
		elseif(state~"gain r1") then
			result:="    A "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") gains "+r1.out + " regen.%N"
		elseif(state~"spawn i") then
			if(enemy.row>0 and enemy.row<=model.warzone.row and enemy.col>0 and enemy.col<=model.warzone.col) then
			result:="      A Interceptor(id:"+enemy.enemy_id.out+") spawns at location ["+model.alphabit.at (enemy.row)+","+enemy.col.out+"].%N"
			else
			result:="      A Interceptor(id:"+enemy.enemy_id.out+") spawns at location out of board.%N"
			end
		elseif(state~"heal enemy") then
			result:="      The Pylon heals "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") at location ["+model.alphabit.at (row)+","+col.out+"] for 10 damage.%N"
		elseif(state~"e projectile collide") then
			result:="      The projectile collides with "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") at location ["+model.alphabit.at (enemy.row)+","+enemy.col.out+
			"], healing "+damage.out+" damage.%N"
		elseif(state~"collide with enemy p") then
			result:="      The "+enemy.enemy_type+" collides with enemy projectile(id:"+projectile_id.out+") at location ["+model.alphabit.at(enemy.row)+
			","+enemy.col.out+"], healing "+damage.out+" damage.%N"
		elseif(state~"collide with enemy p from espawn") then
			result:="      The "+enemy.enemy_type+" collides with enemy projectile(id:"+projectile_id.out+") at location ["+model.alphabit.at(enemy.row)+
			","+enemy.col.out+"], healing "+damage.out+" damage."
		elseif(state~"destroyed from e_spawn") then
			result:="      The "+enemy.enemy_type+" at location ["+model.alphabit.at (row)+","+col.out+"] has been destroyed."
		elseif(state~"destroyed" ) then
			result:="      The "+enemy.enemy_type+" at location ["+model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
		elseif(state~"collide with starfighter") then
			result:="      The "+enemy.enemy_type+" collides with Starfighter(id:0) at location ["+model.alphabit.at (enemy.row)+","+enemy.col.out+
			"], trading "+enemy.health.out+" damage.%N"
		elseif(state~"starfighter destroy") then
			result:="      The Starfighter at location ["+model.alphabit.at (row)+","+col.out+"] has been destroyed.%N"
		elseif(state~"starfighter destroy from e_spawn") then
			result:="      The Starfighter at location ["+model.alphabit.at (row)+","+col.out+"] has been destroyed."
		end
	end
end
