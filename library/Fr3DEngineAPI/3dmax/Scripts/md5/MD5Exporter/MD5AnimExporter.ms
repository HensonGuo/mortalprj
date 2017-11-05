-- Developed by Jonathan "BeRSeRKeR" Garcia
--
-- Credits:
-- Thanks to der_ton and bozo. They show me the solution for some problems I was having
-- with bone orientations. You can find them in http://www.doom3world.org

fileIn "helper_funcs.ms"	-- helper functions

struct sAnimJoint
(
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
	fn calcBBox selGroup frame rootJoint =
	(
		at time frame return #(selGroup.min - rootJoint.basePos, selGroup.max - rootJoint.basePos)
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

	-- Function doExport
	-- Description: exports the md5anim data for "selMeshes" meshes in the given range "animRange"
	-- Returns: returns true on success, false on failed
	fn doExport selMeshes nBaseFrame animRange fileName =
	(
		-- Create the md5anim file to write in
		local fp = createFile fileName

		if fp == undefined do
		(
			local msg = stringStream ""
			format "ERROR!: couldn't create \"%\" file" fileName to: msg
			messageBox (msg as String) title: ".::MD5Exporter::."
			close msg
			return false
		)

		-- Frame rate
		local fps = frameRate	
		-- Number of frames
		local numFrames = (animRange.end.frame - animRange.start.frame + 1) as Integer
		-- Number of animated components
		local numAnimatedComponents = 0
	
		local hierarchy = #()	-- Hierarchy of bones
		local frames = #()		-- Frames

		-- Allocate space for all frames
		frames.count = numFrames
		for nFrame = 1 to numFrames do
			frames[nFrame] = sFrame()
	
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
				append hierarchy joint
	
				-- Calculate animation keys for this bone
				for nTime = animRange.start to animRange.end do
				(
					at time nTime
					(
						local nFrame = (nTime.frame as Integer) - (animRange.start.frame - 1)
						local auxFrame = frames[nFrame]
	
						-- Calculate relative transformation matrix
						local matRelative = Matrix3 1
						if auxBone.parent != undefined do
						(
							matRelative = auxBone.parent.transform
							matRelative = toRightHanded matRelative
							matRelative = inverse matRelative
						)
						matRelative = auxBone.transform * matRelative
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
		)
	
		-- Do parent/child relationship
		for b in hierarchy do
		(
			if b.parentName != undefined do
				b.parentIndex = findBone hierarchy b.parentName
		)
	
		-- Compute bounding boxes
		for nTime = animRange.start to animRange.end do
		(
			local nFrame = (nTime.frame as Integer) - (animRange.start.frame - 1)
			local bb = calcBBox selMeshes nFrame hierarchy[1]

			frames[nFrame].bbMin = bb[1]
			frames[nFrame].bbMax = bb[2]
		)

		-- Write md5mesh header --

		format "MD5Version 10\n" to: fp
		format "commandline \"\"\n\n" to: fp
	
		format "numFrames %\n" numFrames to: fp
		format "numJoints %\n" hierarchy.count to: fp
		format "frameRate %\n" fps to: fp
		format "numAnimatedComponents %\n\n" numAnimatedComponents to: fp

		-- Write hierarchy of bones --

		format "hierarchy {\n" to: fp
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
			format "\t\"%\"\t% % %\t%\n" j.name (j.parentIndex-1) j.flag keyOffs strComment to: fp
		)
		format "}\n\n" to: fp

		-- Write bounding boxes --

		format "bounds {\n" to: fp
		for f in frames do
		(
			local bbMin = roundNearZero f.bbMin
			local bbMax = roundNearZero f.bbMax
			format "\t( % % % ) ( % % % )\n" bbMin.x bbMin.y bbMin.z bbMax.x bbMax.y bbMax.z to: fp
		)
		format "}\n\n" to: fp

		-- Write base frame --

		format "baseframe {\n" to: fp
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
			format "\t( % % % ) ( % % % )\n" pos.x pos.y pos.z rot.x rot.y rot.z to: fp
		)
		format "}\n\n" to: fp

		-- Write animation frames --

		for nFrame = 1 to frames.count do
		(
			f = frames[nFrame]

			-- Write animation keys for the current frame --

			format "frame % {\n" (nFrame - 1) to: fp
			for j in hierarchy do
			(
				numAnimatedComponents = countAnimatedComponents j.flag
				if numAnimatedComponents > 0 do
				(
					format "\t" to: fp
					for i = 0 to (numAnimatedComponents-1) do
					(
						format "% " (roundNearZero f.keys[j.keyOffs + i]) to: fp
					)
					format "\n" to: fp
				)
			)
			format "}\n\n" to: fp
		)
	
		-- Close the output file
		close fp

		-- Alright!
		return true
	)
)