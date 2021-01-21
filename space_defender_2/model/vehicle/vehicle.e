note
	description: "Summary description for {VEHICLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VEHICLE
feature--attributes
	--row and col are the coordinate
	--r1 is the amount of health can gain per turn, can not exceed max
	--r2 is the energy can gain per turn, can not exceed max
	--power is the only way that health can exceed max health
	--enemy's regen can only recover health
	maxhealth,maxenergy,armour,vision,move,move_cost,row,col,power,r1,r2:INTEGER
	row_before,col_before,energy:INTEGER
	health:INTEGER
	model:ETF_MODEL
	alphabit:ARRAY[STRING]
	projectile:PROJECTILE
	projectile_damage:INTEGER
	ma:ETF_MODEL_ACCESS

feature
	regen_health
		do
			if(health>0) then
			if(maxhealth-health>0 and maxhealth-health>r1) then
				health:=health+r1
			elseif(maxhealth-health>0 and maxhealth-health<=r1) then
				health:=health+(maxhealth-health)
			end
			end
		end
	regen_energy
		do
			if(health>0) then
			if(maxenergy-energy>0 and maxenergy-energy>r2) then
				energy:=energy+r2
			elseif(maxenergy-energy<=r2 and maxenergy-energy>0) then
				energy:=energy+(maxenergy-energy)
			end
			end
		end
	regen
		do
			current.regen_energy
			current.regen_health
		end
	make(locate_row,locate_col,po:INTEGER;p_t:STRING;p_d,p_c:INTEGER)
		do

			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>

			row:=locate_row
			col:=locate_col
			power:=po
			model:=ma.m
			create projectile.make (p_t, p_d, p_c)

		end

	--dec col
	startc_dec
		do
			col:=col-1
		end
	--inc col
	startc_inc
		do
			col:=col+1
		end
	--dec row
	startr_dec
		do
			row:=row-1
		end
	--inc row
	startr_inc
		do
			row:=row+1
		end


	--move
	move_action(desrowa:INTEGER;descola:INTEGER)
		local
			i,desrow,descol,diff_col,diff_row,count:INTEGER

		do
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
					i>diff_row or health<=0
				loop

--					if(collide=false) then
					energy:=energy-move_cost
					startr_inc
--					end
					i:=i+1
					checkcollide(row,col)
				end
			elseif(desrowa-row < 0) then
				from
					i:=1
				until
					i>diff_row or health<=0
				loop

--					if(collide=false) then
					energy:=energy-move_cost
					startr_dec
--					end
					i:=i+1
					checkcollide(row,col)
				end

			end --end of if
			if(descola-col > 0) then
				from
					i:=1
				until
					i>diff_col or health<=0
				loop

--					if(collide=false) then
					energy:=energy-move_cost
					startc_inc
--					end
					i:=i+1
					checkcollide(row,col)
				end
			elseif(descola-col < 0) then
				from
					i:=1
				until
					i>diff_col  or health<=0
				loop

--					if(collide=false) then
					energy:=energy-move_cost
					startc_dec
--					end
					i:=i+1
					checkcollide(row,col)
				end
			end --end of if

		end
	checkcollide(r,c:INTEGER)
	deferred
	end

	set_r_c(r,c:INTEGER)
	do
		row:=r
		col:=c
	end

feature --queries
	return_row:INTEGER
	do
		result:=row
	end
	return_col:INTEGER
	do
		result:=col
	end
	return_health:INTEGER
	do
		result:=health
	end
	return_energy:INTEGER
	do
		result:=energy
	end
	return_armour:INTEGER
	do
		result:=armour
	end
	return_vision:INTEGER
	do
		result:=vision
	end
	return_move:INTEGER
	do
		result:=move
	end
	return_movecost:INTEGER
	do
		result:=move_cost
	end
	return_r1:INTEGER
	do
		result:=r1
	end
	return_r2:INTEGER
	do
		result:=r2
	end
	output:STRING
	deferred
	end
	set_health(h:INTEGER)
	do
		health:=h
	end
	set_maxhealth(h:INTEGER)
	do
		maxhealth:=h
	end
	set_vision(v:INTEGER)
	do
		vision:=v
	end

	set_armour(a:INTEGER)
	do
		armour:=a
	end



	inc_energyby(e:INTEGER)
	do
		energy:=energy+e
	end

	dec_energyby(e:INTEGER)
	do
		energy:=energy-e
	end

	dec_health(h:INTEGER)
	DO
		health:=health-h
	end

	inc_health(h:INTEGER)
	DO
		health:=health+h
	end
end
