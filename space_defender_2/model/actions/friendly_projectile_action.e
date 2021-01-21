note
	description: "Summary description for {FRIENDLY_PROJECTILE_ACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_ACTION
	inherit
		PROJECTILE_ACTION
create
	make,make_c_with_enemy,make_destroy_enemy,make_move,make_collide_with_friendly_p,make_collide_with_starfighter

feature
	row,col,row_be,col_be:INTEGER
	p_collided_by:PROJECTILE
	enemy:ENEMY
	c_row,c_col,damage:INTEGER
feature {NONE} -- Initialization
	--contsructor of p collided by p
	make(collide,collide_by:PROJECTILE;c_r,c_c:INTEGER)
			-- Initialization for `Current'.
		do
			--record the collision coordinate
			c_row:=c_r
			c_col:=c_c
			model:=ma.m
			state:=""
			p_collided_by:=collide_by
			projectile:=collide
			create enemy.make (0, 0, 0, "", 0, 0)

		end
	--collide by enemy
	make_c_with_enemy(collide:PROJECTILE;c_b:ENEMY;d:INTEGER)
		do
			damage:=d
			model:=ma.m
			state:="collide_by_enemy"
			projectile:=collide
			enemy:=c_b
			create p_collided_by.make ("", 0, 0)

		end
	--collid and destroy enemy
	make_destroy_enemy(e:ENEMY)
	do
		model:=ma.m
		state:="destroy enemy"
		enemy:=e
		create p_collided_by.make ("", 0, 0)
		create projectile.make ("", 0, 0)
	end

	make_collide_with_friendly_p(p:PROJECTILE)
	do
		state:="collide with friendly p"
		model:=ma.m
		p_collided_by:=p
		create projectile.make ("", 0, 0)
		create enemy.make (0, 0, 0, "", 0, 0)
	end

	make_collide_with_starfighter(p:PROJECTILE;d:INTEGER)
	do
		damage:=d
		state:="collide with starfighter"
		model:=ma.m
		 p_collided_by:=p
		create projectile.make ("", 0, 0)
		create enemy.make (0, 0, 0, "", 0, 0)
	end

	make_move(p:PROJECTILE;r_b,c_b,r,c:INTEGER)
	do
		state:="move"
		model:=ma.m
		create enemy.make (0, 0, 0, "", 0, 0)
		create p_collided_by.make ("", 0, 0)
		projectile:=p
		row_be:=r_b
		col_be:=c_b
		row:=r
		col:=c

	end

feature
	print_p_action:STRING
	do
		model:=ma.m
		result:=""
		if(p_collided_by.type~"<") then
		c_row:=p_collided_by.row
		c_col:=p_collided_by.col

		if(p_collided_by.row > 0 and p_collided_by.row<=model.warzone.row) then
		result:="      The projectile collides with enemy projectile(id:"+p_collided_by.id.out+") at location ["+model.alphabit.at (p_collided_by.row)+","+
		p_collided_by.col.out+"], negating damage.%N"

		end
		end
		if(state~"collide_by_enemy" and projectile.row>0 and projectile.row<=model.warzone.row) then

		result:="      The projectile collides with "+enemy.enemy_type+"(id:"+enemy.enemy_id.out+") at location ["+model.alphabit.at (projectile.row)+
		","+projectile.col.out+"], dealing "+damage.out+" damage.%N"

		elseif(state~"destroy enemy" and enemy.row>0 and enemy.row<=model.warzone.row) then
			result:="      The "+enemy.enemy_type+" at location ["+model.alphabit.at (enemy.row)+","+enemy.col.out+"] has been destroyed.%N"
			model.starfighter.add_orb(enemy.orb)
--			model.starfighter.set_score(enemy.points)
		elseif(state~"move") then
						if(col>0 and col<=model.warzone.col and col_be<=model.warzone.col and col_be>0 and row>0 and row <=model.warzone.row and row_be > 0 and row_be<=model.warzone.row and (row/=row_be or col/=col_be) ) then
							result:="    A friendly projectile(id:"+projectile.id.out+") moves: [" +model.alphabit.at (row_be)+","+col_be.out+"] -> ["+model.alphabit.at (row)+","+col.out+"]%N"

						elseif(col_be<=model.warzone.col and col_be>0 and row_be>0 and row_be <=model.warzone.row ) then
							result:="    A friendly projectile(id:"+projectile.id.out+") moves: [" +model.alphabit.at (row_be)+","+col_be.out+"] -> "+"out of board%N"
							projectile.set_damage(0)
						end
		elseif(state~"collide with friendly p" and p_collided_by.row > 0 and p_collided_by.row<=model.warzone.row and p_collided_by.col > 0 and p_collided_by.col <= model.warzone.col) then
			result:="      The projectile collides with friendly projectile(id:"+p_collided_by.id.out+") at location ["+model.alphabit.at (p_collided_by.row)+","+
		p_collided_by.col.out+"], combining damage.%N"
		elseif(state~"collide with starfighter") then
			result:="      The projectile collides with Starfighter(id:0) at location ["+model.alphabit.at (p_collided_by.row)+","+
			p_collided_by.col.out+"], dealing "+damage.out+" damage.%N"
		end

	end

	print_e_action:STRING
	do
		result:=""
	end

	return_result(r:STRING):STRING
	do
		result:=r
	end
end
