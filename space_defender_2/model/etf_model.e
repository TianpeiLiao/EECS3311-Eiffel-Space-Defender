note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			alphabit:=<<"A","B","C","D","E","F","G","H","I","J">>
			create message.make_empty
			create p.make_empty
			create states_setup.make_empty
			create starfighter.make (0,0,0,"",0,0)
			set_states
			enemy_id:=1
			i := 0
			projectile_id:=-1
			create round.make
			create test_message.make_empty
			create warzone.make
			create total_projectiles.make_empty
			enemy_spawn_mes:=""
			enemy_p_actions:=""
			enemy_pre_action:=""
			enemy_action:=""
			friendly_p_action:=""
			create error.make("")
		end

feature -- model attributes
	error:ERROR
	friendly_p_action:STRING
	enemy_pre_action:STRING
	alphabit:ARRAY[STRING]
	projectile_id:INTEGER
	round:ROUND
	game_start:BOOLEAN
	enemy_p_actions:STRING
	i : INTEGER
	setM:BOOLEAN
	message:STRING
	p:PLAY
	states_setup:ARRAY[STATE_SETUP]
	state_counter:INTEGER
	starfighter:STARFIGHTER
	test_message:STRING
	warzone:WARZONE
	normal_game_counter:INTEGER
	error_game_counter:INTEGER
	debug_mode:BOOLEAN
	enemy_id:INTEGER
	total_projectiles:ARRAY[PROJECTILE]
	enemy_spawn,abort:BOOLEAN
	enemy_spawn_mes:STRING
	enemy_action:STRING
	toggle:BOOLEAN
	iferror:BOOLEAN
feature -- model operations
	set_setM(b:BOOLEAN)
	do
		setM:=b
	end
	set_iferror(b:BOOLEAN)
	do
		iferror:=b
	end
	reset_toggle
	do
		toggle:=false
	end
	clean_friendly_p_action
	do
		friendly_p_action:=""
	end
	set_friendly_p_action(s:STRING)
	DO
		friendly_p_action:=friendly_p_action+s
	end
	clean_enemy_action
	do
		enemy_action:=""
	end
	set_enemy_action(s:STRING)
	do
		enemy_action:=enemy_action+s
	end
	clean_enemy_pre_action
	do
		enemy_pre_action:=""
	end

	set_enemy_pre_action(ss:STRING)
	do
		enemy_pre_action:=enemy_pre_action+ss
	end
	clean_e_p_actions
	do
		enemy_p_actions:=""
	end
	set_enemy_p_actions(ss:STRING)
	DO
		enemy_p_actions:=enemy_p_actions+ss
	end
	set_enemy_spawn_mes(mes:STRING)
	do
		enemy_spawn_mes:=enemy_spawn_mes+mes
	end

	set_enemy_spawn(b:BOOLEAN)
	do
		enemy_spawn:=b
	end

	inc_enemy_id
	do
		enemy_id:=enemy_id+1
	end
	reset_spawn_mes
	do
		enemy_spawn_mes:=""
	end

	dec_projectile_id
	do
		projectile_id:=projectile_id-1
	end
	--
	incre_normal_game_counter
	do
		normal_game_counter:=normal_game_counter+1
		current.reset_error_game_counter
	end

	incre_error_game_counter
	do
		error_game_counter:=error_game_counter+1
	end

	reset_normal_game_counter
	do
		normal_game_counter:=0
	end

	reset_error_game_counter
	do
		error_game_counter:=0
	end

	--toggle
	set_debug_mode(m:BOOLEAN)
	do
		toggle:=true
		debug_mode:=m
	end
	set_game_start(g:BOOLEAN)
	do
		game_start:=g
	end

	set_states
	local
		a:ARMOUR_STATE
		po:POWER_STATE
		e:ENGINE_STATE
		w:WEAPON_STATE
		in:INITIAL_STATE
		summary:SUMMARY_STATE
		testing:STRING
	do
		create in.make
		states_setup.force(in,states_setup.count+1)
		create w.make
		states_setup.force(w,states_setup.count+1)
		create a.make
		states_setup.force(a,states_setup.count+1)
		create e.make
		states_setup.force(e,states_setup.count+1)
		create po.make
		states_setup.force(po,states_setup.count+1)
		create summary.make
		states_setup.force(summary,states_setup.count+1)
	end
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end
	setmessage(m:STRING)
		do
			setM:=true
			message:=m
		end

	play(row,col,n1,n2,n3,n4,n5:INTEGER)
		do
			game_start:=false
			current.clean_e_p_actions
			current.clean_friendly_p_action
			current.clean_enemy_action
			enemy_spawn_mes:=""
			clean_enemy_pre_action
			clean

			create p.make (row, col, n1, n2, n3, n4, n5)
		end

	pass
		local
			pas:PASS
		do
			create pas.make
			round.set_action (pas)
			warzone.setwar_zone (p)

		end
	set_abort
	do
--		across
--			states_setup is st
--		loop
--			st.reset
--		end

		abort:=true

	end

	clean
	do
		current.clean_e_p_actions
		current.clean_friendly_p_action
		current.clean_enemy_action
		clean_enemy_pre_action
		setM:=false

		round.change_action (create {ACTION}.make)
		game_start:=false
		state_counter:=1
		normal_game_counter:=0
		starfighter.clea_p
		projectile_id:=-1
		enemy_id:=1
		create total_projectiles.make_empty
		across
			round.enemys is es
		loop
			es.clean
		end
		round.clean_enemys
	end
	move(desr,desc:INTEGER)
		local
			mov:MOVE
		do
			create mov.make
			starfighter.set_des_rc (desr, desc)
			round.set_action (mov)
		end

	fire
		local
			fir:FIRE
		do
			create fir.make
			check attached {WEAPON_STATE} states_setup.at (2) as w_s then
			if(starfighter.projectile.cost>starfighter.health+starfighter.r1 and w_s.arrays.at(w_s.selected_index).type~"Rocket") then
				error.set_state ("  Not enough resources to fire.")
			elseif(starfighter.energy+starfighter.r2-starfighter.projectile.cost<0 and w_s.arrays.at(w_s.selected_index).type/~"Rocket") then
				error.set_state ("  Not enough resources to fire.")
			else
				reset_error_game_counter
				incre_normal_game_counter
				round.set_action (fir)
				end
			end
		end

	special
		local
			spec:SPECIAL_ACTION
		do
			create spec.make
			check attached {POWER_STATE} states_setup.at (5) as w_s then
				if(w_s.powers.at(w_s.selected_index).amount>starfighter.energy+starfighter.r2 and w_s.powers.at(w_s.selected_index).type/~"overcharge") then
					error.set_state ("  Not enough resources to use special.")
				else
			reset_error_game_counter
			incre_normal_game_counter
			round.set_action(spec)
			end
			end
		end

	set_state_counter(ss:INTEGER)
		do
			setM:=true
			state_counter:=ss
		end


	start
		local
			h,e,r1,r2,a,v,mo,mo_co:INTEGER
			sr:REAL_64
			locate_row:INTEGER
		do
			create starfighter.make (0,0,0,"",0,0)
			create total_projectiles.make_empty
			round.clean_enemys
			setM:=false
			sr:=p.row/2
			locate_row:=sr.ceiling

			check attached {WEAPON_STATE} current.states_setup.at (2) as w_s then
				create starfighter.make (locate_row, 1, 0, w_s.projectiles.at (w_s.selected_index).pattern, w_s.projectiles.at (w_s.selected_index).damage, w_s.projectiles.at (w_s.selected_index).cost)
				starfighter.set_spawn_rc (locate_row, 1)
				starfighter.set (w_s.arrays.at (w_s.selected_index))
			end
			check attached {ARMOUR_STATE} current.states_setup.at (3) as w_s then
				starfighter.set (w_s.arrays.at (w_s.selected_index))
			end
			check attached {ENGINE_STATE} current.states_setup.at (4) as w_s then
				starfighter.set (w_s.arrays.at (w_s.selected_index))
			end
			current.warzone.setwar_zone (p)
			end
	add_total_projectile(ppp:PROJECTILE)
		DO
			total_projectiles.force (ppp, total_projectiles.count+1)
		end
feature -- queries
	

	reset_test_m
	do
		test_message:=""
	end
	out : STRING
		do
			Result:=states_setup.at (1).out

			if(abort=true and debug_mode=false and setM=false) then
				result:="  state:not started, normal, ok%N"+
  						"  Exited from game."
  			elseif(abort=true and debug_mode=true and setM = false) then
  				result:="  state:not started, debug, ok%N"+
  						"  Exited from game."
			end


			if(abort=true) then
					game_start:=false

					if(debug_mode=true and setM=true and game_start=false) then
						result:="  state:not started, debug, ok%N"
						result:=result+"  Exited from setup mode."
					elseif(debug_mode=false and setM=true and game_start=false) then
						result:="  state:not started, normal, ok%N"
						result:=result+"  Exited from setup mode."
					elseif(debug_mode=false and setM=false and game_start=false) then
						result:="  state:not started, normal, ok%N"
						result:=result+"  Exited from game."
					elseif(debug_mode=false and setM=false and game_start=false) then
						result:="  state:not started, debug, ok%N"
						result:=result+"  Exited from game."
					end
					clean

			end


			--before the game start, dislay setup info
			if(setM=true and toggle=false and abort=false) then
			Result:=states_setup.at (state_counter).out
			end


			--if
			--display just debug
			if(toggle = true) then
			result:=print_state
			if(debug_mode=true) then
				result:=result+	"  In debug mode."
				else
				result:=result+"  Not in debug mode."
				end
				toggle:=false
			--else if
			--after the game start, display warzone and starfighter,enenmy projectile,friendly projectile action,
			--enemy projectile action, starfighter action,enemy action,enemy spawn
			elseif(current.game_start=true and toggle=false) then
				--print state
				result:=print_state
				--info from starfighter
				result:=result+starfighter.output
				if(current.debug_mode=true and toggle=false) then
				--enemy
				result:=result+"%N  Enemy:" + "%N"
				result:=result+round.print_enemy
				--projectile
				result:=result+"  Projectile:" + "%N"
				across
					total_projectiles is ps
				loop

					if(ps.col<=warzone.col and ps.col>=1 and ps.row>=1 and ps.collision=false and ps.row<=warzone.row and ps.damage>0) then
					result:=result+"    ["+ps.id.out+","+ps.type+"]->damage:"+ps.damage.out+", move:"+ps.move.out+", location:["+starfighter.alphabit.at (ps.row)+","+ps.col.out+"]%N"
					end

				end
				--friendly projectile action
				result:=result+"  Friendly Projectile Action:" + "%N"
				result:=result+friendly_p_action

				--enemy projectile action
				result:=result+"  Enemy Projectile Action:" + "%N"
				result:=result+enemy_p_actions
				--starfighter action
				result:=result+"  Starfighter Action:" + "%N"
				if(starfighter.if_print_output_action=true) then
				result:=result+starfighter.output_action
				end
				--enemy action
				result:=result+"  Enemy Action:" + "%N"
				result:=result+enemy_pre_action

				result:=result+enemy_action

				--enemy spawn
				result:=result+"  Natural Enemy Spawn:"
				if(current.enemy_spawn=true and starfighter.health>0) then
				result:=result+enemy_spawn_mes
				end
				set_enemy_spawn(false)
				--warzone layer
				end
				result:=result+"%N"+current.warzone.outputA
				--if exited
				if(starfighter.health<=0) then
				result:=result+"%N  The game is over. Better luck next time!"
				clean
				end
			end

			--testing
			if(test_message/=void) then
				result:=result+current.test_message
			end

			--reset abort
			abort:=false
			if(iferror=true) then
				result:=error.state
			end
			iferror:=false


		end
	reset_enemy_spawn_mes
	do
				enemy_spawn_mes:=""
	end
	--print states
	print_state:STRING
		do
		 	result:=""
		 	if(setM=false) then
				if(debug_mode=false) then
					result:="  state:in game(" + normal_game_counter.out+"." + error_game_counter.out+"), normal, ok%N"
				elseif(debug_mode=true and setM=true) then
					result:="  state:"+current.states_setup.at (current.state_counter).state+", debug, ok%N"
				elseif(debug_mode=true and setM=false) then
					result:="  state:in game(" + current.normal_game_counter.out+"." + error_game_counter.out+"), debug, ok%N"
				end
			end
			if(setM=true) then
				result:=current.states_setup.at (state_counter).print_state
			end

			if((starfighter.health<=0 or game_start=false) and setM=false and debug_mode=true) then
				result:="  state:not started, debug, ok%N"
			elseif((starfighter.health<=0 or game_start=false) and setM=false and debug_mode=false) then
				result:="  state:not started, normal, ok%N"
			end
		end

end




