note
	description: "Summary description for {ORB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORB
create
	make
feature
	points:INTEGER
	array:ARRAY[ORB]
	--max size denotes the max number of orb that in this class, e.g. diamond has 3 max size
	max_size:INTEGER
	--award is for diamond and platinum focus
	--diamond tripple,platinum double
	award:INTEGER
	name:STRING
	model:ETF_MODEL
	ma:ETF_MODEL_ACCESS
feature
	make
	do
		name:=""
		create array.make_empty
		model:=ma.m
	end
	add_orb(o:ORB)
	do
		--array.at (array.count).array.count<array.at (array.count).max_size
		if(array.count=0) then
			array.force (o, array.count+1)
		elseif((array.at (array.count).name~"diamond" or array.at (array.count).name~"platinum") and array.at (array.count).array.count<array.at (array.count).max_size) then
			array.at (array.count).add_orb (o)
		ELSE
			array.force (o, array.count+1)
		end
	end

	get_points:INTEGER
	do
		model:=ma.m
		if(max_size>1 and max_size=array.count) then
			across
				array is es
			loop
				result:=result+(es.get_points*award)
			end
			result:=result
		elseif(max_size>1 and array.count<max_size) then
			across
				array is es
			loop
				result:=result+es.get_points
			end

		elseif(max_size=1) then
			result:=points
		end

	end
end
