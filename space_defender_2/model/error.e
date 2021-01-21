note
	description: "Summary description for {ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR
create
	make
feature
	state:STRING
	model:ETF_MODEL
	ma:ETF_MODEL_ACCESS
feature
	make(s:STRING)
	DO
		state:=""
		model:=ma.m
	end

	set_state(s:STRING)
	do
		state:=print_state+s
		model.set_iferror (true)
	end

	print_state:STRING
	do
		model:=ma.m
		result:=""
					if(model.debug_mode=false and model.setM=false and model.game_start=true) then
						model.incre_error_game_counter
						result:="  state:in game(" + model.normal_game_counter.out+"." + model.error_game_counter.out+"), normal, error%N"
					elseif(model.debug_mode=true and model.setM=false and model.game_start=true) then
						model.incre_error_game_counter
						result:="  state:in game(" + model.normal_game_counter.out+"." + model.error_game_counter.out+"), debug, error%N"
					elseif(model.debug_mode=true and model.setM=true and model.game_start=false) then
						result:="  state:"+model.states_setup.at (model.state_counter).state+", debug, error%N"
					elseif(model.debug_mode=false and model.setM=true and model.game_start=false) then
						result:="  state:"+model.states_setup.at (model.state_counter).state+", normal, error%N"
					elseif(model.debug_mode=false and model.setM=false and model.game_start=false) then
						result:="  state:not started, normal, error%N"
					elseif(model.debug_mode=true and model.setM=false and model.game_start=false) then
						result:="  state:not started, debug, error%N"
					end

	end
end
