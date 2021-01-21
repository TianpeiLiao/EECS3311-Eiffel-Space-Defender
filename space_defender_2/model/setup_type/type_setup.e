note
	description: "Summary description for {TYPE_SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TYPE_SETUP


feature --attributes
	health,energy,armour,vision,move,movecost,r1,r2:INTEGER
	type:STRING
feature {NONE} -- Initialization

	make(h,e,a,v,m1,m2,r11,r22:INTEGER;t:STRING)
			-- Initialization for `Current'.
		do
			create type.make_empty
			health:=h
			energy:=e
			armour:=a
			vision:=v
			move:=m1
			movecost:=m2
			r1:=r11
			r2:=r22
			type:=t
		end
feature --queries
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
		result:=movecost
	end
	return_r1:INTEGER
	do
		result:=r1
	end
	return_r2:INTEGER
	do
		result:=r2
	end
	return_type:STRING
	do
		result:=type
	end
end
