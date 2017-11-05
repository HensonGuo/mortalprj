-- Developed by Jonathan "BeRSeRKeR" Garcia
--
-- Credits:
-- Thanks to der_ton and bozo. They show me the solution for some problems I was having
-- with bone orientations. You can find them in http://www.doom3world.org

fileIn "helper_funcs.ms"	-- helper functions

struct sAnimJoint
(
	joinNode,
	name,			-- name of the bone
	parentName,		-- name of the parent
	parentIndex,	-- index of the parent
	flag,			-- indicates what componentes are animated:
					-- 1 = > Tx
					-- 2  => Ty
					-- 4  => Tz
					-- 8  => Qx
					-- 16 => Qy
					-- 32 => Qz
	keyOffs,		-- start position of the animated components in "keys" list
	basePos,		-- base position
	baseRot			-- base rotation
)

struct sFrame
(
	frame,
	time,
	bbMin,			-- bounding box minimum point
	bbMax,			-- bounding box maximum point
	keys = #()		-- list animated components
)

struct MD5AnimExporter
(
	-- Function: calcBBox
	-- Description: calculates the bounding box for a given object set "selGroup"
	--				at a given frame "frame"
	-- Return: returns the object set bounding box
	fn calcBBox selGroup frame =
	(
		at time frame return #(selGroup.min, selGroup.max,selGroup.center)
	),
	-- Function: animated
	-- Description: looks if the component "c" for the node "node" is animated
	--				in the given range "animRange"
	-- Return: returns true if is animated, otherwise returns false
	fn animated node c animRange =
	(
		-- Is the node animated? (fast rejection)
		if node.isAnimated == false then return false

		in coordsys parent	-- Is this right?
		(
			local pos = node.transform.row4
			local rot = node.transform.rotationPart

			-- What component are we testing?
			case c of
			(
				#Tx:
				(
					at time 0
					local x =  node.transform.row4.x
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.row4.x - x)) > 0.00001 do return true
					)
				)
				#Ty:
				(
					at time 0
					local y = node.transform.row4.y
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.row4.y - y)) > 0.00001 do return true
					)
				)
				#Tz:
				(
					at time 0
					local z = node.transform.row4.z
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.row4.z - z)) > 0.00001 do return true
					)
				)
				#Qx:
				(
					at time 0
					local qx = node.transform.rotationPart.x
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.rotationPart.x - qx)) > 0.00001 do return true
					)
				)
				#Qy:
				(
					at time 0
					local qy = node.transform.rotationPart.y
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.rotationPart.y - qy)) > 0.00001 do return true
					)
				)
				#Qz:
				(
					at time 0
					local qz = node.transform.rotationPart.z
					for i = animRange.start to animRange.end do
					(
						at time i
						if (abs (node.transform.rotationPart.z - qz)) > 0.00001 do return true
					)
				)
			)
		)
		-- The component is not animated
		return false
	),


	-- Function buildAnimatedComponentsFlag
	-- Description: builds the animated components flag for the given node "node"
	--				in the given range "animRange"
	-- Returns: returns the animation flag
	fn buildAnimatedComponentsFlag node animRange =
	(
		local flag = 0
	
		if (animated node #Tx animRange) == true do flag += 1
		if (animated node #Ty animRange) == true do flag += 2
		if (animated node #Tz animRange) == true do flag += 4
		if (animated node #Qx animRange) == true do flag += 8
		if (animated node #Qy animRange) == true do flag += 16
		if (animated node #Qz animRange) == true do flag += 32
	
		return flag
	),

	-- Function isFlagSet
	-- Description: tests if a given "c" component is set into "flag"
	-- Returns: returns true if the component "c" is set in "flag"
	fn isFlagSet flag c =
	(
		if (c == #Tx) and ((bit.and flag 1)  == 1)  then return true
		if (c == #Ty) and ((bit.and flag 2)  == 2)  then return true
		if (c == #Tz) and ((bit.and flag 4)  == 4)  then return true
		if (c == #Qx) and ((bit.and flag 8)  == 8)  then return true
		if (c == #Qy) and ((bit.and flag 16) == 16) then return true
		if (c == #Qz) and ((bit.and flag 32) == 32) then return true
		return false
	),

	-- Function countAnimatedComponents
	-- Description: counts the number of animated components for the given flag "flag"
	-- Returns: returns the number of animated components for "flag"
	fn countAnimatedComponents flag =
	(
		local n = 0
	
		if (isFlagSet flag #Tx) == true do n += 1
		if (isFlagSet flag #Ty) == true do n += 1
		if (isFlagSet flag #Tz) == true do n += 1
		if (isFlagSet flag #Qx) == true do n += 1
		if (isFlagSet flag #Qy) == true do n += 1
		if (isFlagSet flag #Qz) == true do n += 1
	
		return n
	),
	
	fn writeFrame hierarchy frames fps fp=
	(
		for joint in hierarchy do
		(
			-- Calculate animation keys for this bone
			for nTime = 1 to frames.count do
			(
				local auxFrame = frames[nTime]
				at time auxFrame.frame
				(
					-- Calculate relative transformation matrix
					local matRelative = Matrix3 1
					if joint.joinNode.parent != undefined do
					(
						matRelative = joint.joinNode.parent.transform
						matRelative = toRightHanded matRelative
						matRelative = inverse matRelative
					)
					matRelative = joint.joinNode.transform * matRelative
					matRelative = toRightHanded matRelative

					-- Position & rotation for the current bone
					local pos = matRelative.row4
					local rot = matRelative.rotationPart
					if rot.w < 0 do
					(
						rot.x = -rot.x
						rot.y = -rot.y
						rot.z = -rot.z
					)

					-- Only add the animated components for the current bone!
					if (isFlagSet joint.flag #Tx) == true do append auxFrame.keys pos.x
					if (isFlagSet joint.flag #Ty) == true do append auxFrame.keys pos.y
					if (isFlagSet joint.flag #Tz) == true do append auxFrame.keys pos.z
					if (isFlagSet joint.flag #Qx) == true do append auxFrame.keys rot.x
					if (isFlagSet joint.flag #Qy) == true do append auxFrame.keys rot.y
					if (isFlagSet joint.flag #Qz) == true do append auxFrame.keys rot.z
				)
			)
		)
		
		for nFrame = 1 to frames.count do
		(
			f = frames[nFrame]
			--format "keyframe % {\n" nFrame to: fp
			for j in hierarchy do
			(
				numAnimatedComponents = countAnimatedComponents j.flag
				if numAnimatedComponents > 0 do
				(
					for i = 0 to (numAnimatedComponents-1) do
					(
						--format "% " (roundNearZero f.keys[j.keyOffs + i]) to: fp
						writefloat fp (roundNearZero f.keys[j.keyOffs + i])
					)
				)
			)
		)
	),
	fn AnimateTrack timeinterval sampleTime =
	(
		frames = #()
		animEnd=timeinterval.end.frame;
		animStart=timeinterval.start.frame;
		local disTimes = (animEnd - animStart)/sampleTime+1;
		local numFrames = disTimes as Integer;
		
		for i = 1 to numFrames do
		(
			frames[i] = sFrame()
			frames[i].frame=(animStart+(i-1)*sampleTime)
			frames[i].time=frames[i].frame/framerate;
		)
		if frames[numFrames]!=animEnd do
		(
			numFrames=numFrames+1;
			frames[numFrames] = sFrame()
			frames[numFrames].frame=animEnd;
			frames[numFrames].time=animEnd/framerate;
			
		)
		return frames
	),

	-- Function doExport
	-- Description: exports the md5anim data for "selMeshes" meshes in the given range "animRange"
	-- Returns: returns true on success, false on failed
	fn doExport nodeList nBaseFrame fileName =
	(
		-- Create the md5anim file to write in
		--local fp = createFile fileName
		
		local fp=fopen fileName "wb"
		
		if fp == undefined do
		(
			
			messageBox ("ERROR!: couldn't create \""+fileName+"\" file" )
			return false
		)
		
		animRange=animationRange

		-- Number of animated components
		local numAnimatedComponents = 0
	
		local hierarchy = #()	-- Hierarchy of bones
		
		
		-- Frame rate
		local fps = frameRate	
		
		
		
		
		-- Collect all the bones in the scene
		for auxBone in $* do
		(
			-- -- Is the current node a bone?
			if ((classOf auxBone) == BoneGeometry) or ((classOf auxBone) == Biped_Object) do
			(			
				-- Create a new bone
				joint = sAnimJoint()

				-- Name of the bone
				joint.name = auxBone.name

				-- Has the bone a parent?
				if auxBone.parent == undefined then
				(
					-- No
					joint.parentIndex = 0
					joint.parentName = undefined
				)
				else
				(
					-- Yeah!
					joint.parentName = auxBone.parent.name
				)
	
				-- Calculate number of animated components for this bone
				joint.flag = buildAnimatedComponentsFlag auxBone animRange
				-- Increment number of overall animated components
				numAnimatedComponents += countAnimatedComponents joint.flag
	
				-- Calculate the start position of the animated components for this bone
				-- into the list of animation keys of the current bone
				joint.keyOffs = 0
				if joint.flag != 0 do
				(
					if hierarchy.count > 0 then
					(
						local nJoint = hierarchy.count
						while (nJoint > 0) and (hierarchy[nJoint].keyOffs) == 0 do
						(
							nJoint -= 1
						)
						if nJoint > 0 then
						(
							local num = countAnimatedComponents hierarchy[nJoint].flag
							joint.keyOffs = hierarchy[nJoint].keyOffs + num
						)
						else joint.keyOffs = 1
					)
					else joint.keyOffs = 1
				)

				-- Calculate base frame
				at time nBaseFrame
				(
					-- Calculate the relative transformation matrix
					local matRelative = Matrix3 1
					if auxBone.parent != undefined do
					(
						matRelative = auxBone.parent.transform
						matRelative = toRightHanded matRelative
						matRelative = inverse matRelative
					)
					matRelative = auxBone.transform * matRelative
					matRelative = toRightHanded matRelative

					--  Base frame position & rotation
					joint.basePos = matRelative.row4
					joint.baseRot = matRelative.rotationPart
				)
	
				-- Add the bone to the hierarchy list
				joint.joinNode=auxBone;
				append hierarchy joint
	
				
			)
		)
		
		-- Do parent/child relationship
		for b in hierarchy do
		(
			if b.parentName != undefined do
				b.parentIndex = findBone hierarchy b.parentName
		)
		names=getObjectSeting $ "objAnimate" "anims_names" true
		startframes=getObjectSeting $ "objAnimate" "anims_startframes" true
		endframes=getObjectSeting $ "objAnimate" "anims_endframes" true
		lengths=getObjectSeting $ "objAnimate" "anims_lengths" true
		
		num=startframes.count
		tracksNum=num;
		if num==0 do tracksNum=1;
		-- Write md5mesh header --

		magic=0x2100
		version=1
		writeshort fp magic #unsigned
		writeshort fp version #unsigned

		writeshort fp hierarchy.count #unsigned
		writeshort fp numAnimatedComponents #unsigned
		writeshort fp tracksNum #unsigned

		for i=1 to num do
		(	
			writeString fp names[i]
		)
		if num==0 do
		(
			writeString fp "default"
		)
		
		-- Write hierarchy of bones --
		for j in hierarchy do
		(
			local keyOffs = 0
			if j.keyOffs > 0 do keyOffs = j.keyOffs - 1
	
			local strComment = "// "
			if j.parentName != undefined do strComment += j.parentName
			if j.flag != 0 do
			(
				strComment += " ( "
				if (isFlagSet j.flag #Tx) == true do strComment += "Tx "
				if (isFlagSet j.flag #Ty) == true do strComment += "Ty "
				if (isFlagSet j.flag #Tz) == true do strComment += "Tz "
				if (isFlagSet j.flag #Qx) == true do strComment += "Qx "
				if (isFlagSet j.flag #Qy) == true do strComment += "Qy "
				if (isFlagSet j.flag #Qz) == true do strComment += "Qz "
				strComment += ")"
			)
			--format "\t\"%\"\t% % %\t%\n" j.name (j.parentIndex-1) j.flag keyOffs strComment to: fp
			writeString fp j.name
			writeshort fp (j.parentIndex-1)
			writeshort fp j.flag #unsigned
			writeshort fp keyOffs #unsigned
		)
		
		


		-- Write base frame --
		for j in hierarchy do
		(
			local pos = roundNearZero j.basePos
			local rot = roundNearZero j.baseRot
			if rot.w < 0 do
			(
				rot.x = -rot.x
				rot.y = -rot.y
				rot.z = -rot.z
			)
			--format "\t( % % % ) ( % % % )\n" pos.x pos.y pos.z rot.x rot.y rot.z to: fp
			writefloat fp pos.x
			writefloat fp pos.y
			writefloat fp pos.z
			writefloat fp rot.x
			writefloat fp rot.y
			writefloat fp rot.z
		)

		
		-- Write animation frames --
		for i=1 to num do
		(	
			animateStart=startframes[i]
			animEnd=endframes[i]
			sampleTime=lengths[i]

			timeInterval=interval animateStart animEnd
			frames=AnimateTrack timeInterval sampleTime

			--format "numFrames %\n" frames.count to: fp
			writeshort fp frames.count #unsigned
			
			local nFrame = animateStart as Integer
			local bb = calcBBox nodeList nFrame
			
			--format "boundsMin % % %\n" bb[1].x bb[1].y bb[1].z to: fp
			--format "boundsMax % % %\n" bb[2].x bb[2].y bb[2].z to: fp
			--format "boundsCenter % % %\n" bb[3].x bb[3].y bb[3].z to: fp

			writefloat fp bb[1].x
			writefloat fp bb[1].y
			writefloat fp bb[1].z
			
			writefloat fp bb[2].x
			writefloat fp bb[2].y
			writefloat fp bb[2].z
			
			writefloat fp bb[3].x
			writefloat fp bb[3].y
			writefloat fp bb[3].z
			
			writeFrame hierarchy frames fps fp
		)
		if num==0 do
		(
			sampleTime=3
			frames=AnimateTrack animationRange sampleTime
			--format "numFrames %\n" frames.count to: fp
			writeshort fp frames.count #unsigned

			local bb = calcBBox nodeList 0
			
			--format "boundsMin % % %\n" bb[1].x bb[1].y bb[1].z to: fp
			--format "boundsMax % % %\n" bb[2].x bb[2].y bb[2].z to: fp
			--format "boundsCenter % % %\n" bb[3].x bb[3].y bb[3].z to: fp
			writefloat fp bb[1].x
			writefloat fp bb[1].y
			writefloat fp bb[1].z
			
			writefloat fp bb[2].x
			writefloat fp bb[2].y
			writefloat fp bb[2].z
			
			writefloat fp bb[3].x
			writefloat fp bb[3].y
			writefloat fp bb[3].z
			
			writeFrame hierarchy frames fps fp
		)
	
		-- Close the output file
		fclose fp

		-- Alright!
		return true
	)
)