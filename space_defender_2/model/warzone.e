note
	description: "Summary description for {WARZONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WARZONE

create
	make
feature --attributes
	war_layer:ARRAY2[STRING]
	row,col:INTEGER
	alphabit:ARRAY[STRING]
	play:PLAY
	model:ETF_MODEL

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			ma:ETF_MODEL_ACCESS
		do
			model:=ma.m
			create war_layer.make_filled("",row,col)
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			create play.make_empty
		end
feature --commands
	setwar_zone(p:PLAY)
		local
			ma:ETF_MODEL_ACCESS
		do
			row:=p.row
			col:=p.column
			play:=p
			model:=ma.m
			if(model.debug_mode=false) then
			create war_layer.make_filled ("?", row, col)
			current.war_fog
			else
			create war_layer.make_filled ("_", row, col)
			end
			war_layer.put ("S", model.starfighter.row, model.starfighter.col)


		end

	distance(sr,sc,r,c:INTEGER):INTEGER
	local
		diff_row,diff_col:INTEGER
		ma:ETF_MODEL_ACCESS
	do
		model:=ma.m
		diff_row := sr-r
		diff_col:=sc-c
		diff_row:=diff_row.abs
		diff_col:=diff_col.abs
		result:=diff_row+diff_col
	end
	--output warzone
	outputA:STRING
		local
			j,k,z:INTEGER
			s:STRING
		do
			if(model.debug_mode=false) then
			create war_layer.make_filled ("?", row, col)
			current.war_fog
			else
			create war_layer.make_filled ("_", row, col)
			end
			--print starfighter
			if(model.starfighter.health>0) then
			war_layer.put ("S", model.starfighter.row, model.starfighter.col)
			elseif(model.starfighter.health<=0) then
			war_layer.put ("X", model.starfighter.row, model.starfighter.col)
			end
			--print enemy spot
			across
				model.round.enemys is es
			loop
				if(es.row>=1 and es.row<=row and es.col>=1 and es.col<=col and es.health>0 and war_layer.item (es.row,es.col).out/~"?") then
				war_layer.put (es.symbol, es.row, es.col)
				end
				across
					es.enemy_projectiles is ps
				loop
					if(ps.row>=01 and ps.row<=row and ps.col>=1 and ps.col<=col and ps.damage>0 AND war_layer.item (ps.row, ps.col).out/~"?") then
					war_layer.put ("<", ps.row, ps.col)

					end
				end
			end

			--print friendly projectiles
			current.print_projectile

			--adjust the layer according to war_layer, does not change any context
			s:=""
			from
				k:=1
			until
				k>row
			loop
				from
					j:=1
				until
					j>col
				loop
					if(j=1 and k=1)
						then

						from
							z:=1
						until
							z>col
						loop
							if(z=1) then s:=s+"    " end
							if(z<=9) then
--							s:=s+z.out + "  "
							s:=s+"  "+z.out
							elseif(z>9)then
--							s:=s+z.out+" "
							s:=s+" "+z.out
							end
							if(z=col) then s:=s+"%N"

							end
							z:=z+1
						end
						end
					if(j=1) then
						s:=s+"    "+alphabit[k]
						s:=s+" "+war_layer[k,j]
					else
--					s:=s+array2[k,j]+"  "
					s:=s+"  "+war_layer[k,j]
					end
					if(j=col and k/=row) then s:=s+"%N" end
					j:=j+1
				end

				k:=k+1
			end
			result:=s
		end
feature --commands
	--print starfighter projectiles
	print_projectile
		do
			across
				model.starfighter.starfightr_projectiles
			is
				p
			loop
				if(p.row>= 1 and p.row <= row and p.col>=1 and p.col<=col and p.damage>0 AND war_layer.item (p.row, p.col).out/~"?") then
				war_layer.put ("*", p.row, p.col)
				end
			end
		end
	war_fog
	local
		i,j:INTEGER
		ma:ETF_MODEL_ACCESS
	do
		--examine each row
		model:=ma.m
		from
			i:=1
		until
			i>current.war_layer.height
		loop

--			if(i<model.starfighter.row)then
--				diff:=model.starfighter.row-i
--			end
--			if(i=model.starfighter.row)then
--				diff:=0
--			end
--			if(i>model.starfighter.row)then
--				diff:=i-model.starfighter.row
--			end
			--examine each col
			from
				j:=1
			until
				j>current.war_layer.width
			loop
--				if(i=model.starfighter.row and j<=model.starfighter.vision+model.starfighter.col) then
--					current.war_layer.put ("_", i, j)
--				end
--				if(j<=model.starfighter.vision-diff+model.starfighter.col) then
--					current.war_layer.put ("_", i, j)
--				end
				if(distance(model.starfighter.row,model.starfighter.col,i,j)<=model.starfighter.vision) then
					current.war_layer.put ("_", i, j)
				end
				j:=j+1
			end
			i:=i+1
		end
	end

end
