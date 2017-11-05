-- Developed by Jonathan "BeRSeRKeR" Garcia

fileIn "MD5MeshExporter.ms"		-- The mesh exporter
fileIn "MD5AnimExporter.ms"		-- The animation exporter
fileIn "MD5CameraExporter.ms"	-- The camera exporter

rollout roAbout ".::About::." width:160
(
	bitmap bmpBanner "" pos:[0,8] width:160 height:85 fileName:"MD5ExporterBanner.jpg"
	button btnAbout "About" pos:[8,96] width:144 height:18

	on btnAbout pressed do
	(
		messageBox "-- Developed by Jonathan \"BeRSeRKeR\" Garcia --" title: ".:: MD5 Exporter v0.1 ::." beep: false
	)
)

rollout roMD5MeshAnim ".::Mesh & Animation::." width:160 height:584
(
	-- Order of the rollout components matter! --

	GroupBox grpFrameOptions " Frame options " pos:[8,16] width:144 height:104

	spinner spnBaseFrame "Base frame " pos:[29,47] width:108 height:16 enabled:true type:#integer scale:1
	spinner spnStartFrame "Start frame  " pos:[28,69] width:109 height:16 enabled:true type:#integer scale:1
	spinner spnEndFrame "End frame   " pos:[28,94] width:109 height:16 enabled:true type:#integer scale:1

	listbox lbxNodes "Nodes to export:" pos:[8,136] width:144 height:8
	
	-- "Add" button filter function
	fn filterFn node =
	(
		-- Skip objects already in the list of nodes and non geometric objects
		-- Particle nodes are geometric objects so we discard them here!
		return
		(
			((findItem lbxNodes.items node.name) == 0) and (superClassOf node == GeometryClass) and
			(classOf node != BoneGeometry) and (classOf node != Biped_Object) and
			(classOf node != Blizzard) and (classOf node != PF_Source) and (classOf node != Spray) and
			(classOf node != PCloud) and (classOf node != Snow) and
			(classOf node != PArray) and (classOf node != SuperSpray)
		)
	)

	pickbutton btnPickNode "Add" pos:[16,272] width:56 height:18 enabled:true message:"" filter:filterFn toolTip:""
	button btnRemove "Remove" pos:[80,272] width:64 height:18
	label lblAddInfo "Add = pick a scene node" pos:[22,296] width:120 height:16
	GroupBox grpExpOptions " Export options " pos:[8,336] width:144 height:80
	radiobuttons rdoOptions "" pos:[16,360] width:127 height:48 labels:#("Export MD5Mesh only", "Export MD5Anim only", "Export both")
	button btnExport "---> Export <---" pos:[32,440] width:96 height:18

	-- animationRange callback function
	fn roMD5MeshAnim_updateFrames_cb =
	(
		-- New animation ranges
		local start = animationRange.start.frame as Integer
		local end = animationRange.end.frame as Integer

		-- When the spinners range changes, the values are reset to 0
		-- so save the current spinners values...
		local baseFrame = spnBaseFrame.value
		local startFrame = spnStartFrame.value
		local endFrame = spnEndFrame.value

		-- Update spinners ranges
		spnBaseFrame.range = spnStartFrame.range = spnEndFrame.range = [start, end, 0]

		-- Restore the previous values
		spnBaseFrame.value = baseFrame
		spnStartFrame.value = startFrame
		spnEndFrame.value = endFrame
	)

	on roMD5MeshAnim open do
	(
		local start = animationRange.start.frame as Integer
		local end = animationRange.end.frame as Integer
	
		spnBaseFrame.range = spnStartFrame.range = spnEndFrame.range = [start, end, 0]
	
		spnBaseFrame.value = start
		spnStartFrame.value = start + 1
		spnEndFrame.value = end

		rdoOptions.state = 3
		
		-- Register animationRange callback function
		registerTimeCallback roMD5MeshAnim_updateFrames_cb
	)

	on roMD5MeshAnim close do
	(
		-- Unregister animationRange callback function
		unRegisterTimeCallback roMD5MeshAnim_updateFrames_cb
	)

	on btnPickNode picked node do
	(
		lbxNodes.items += #(node.name)
	)

	on btnRemove pressed do
	(
		if (lbxNodes.items.count > 0) and (lbxNodes.selection > 0) do
		(
			deleteItem lbxNodes.items lbxNodes.selection
			lbxNodes.items = lbxNodes.items
		)
	)

	on btnExport pressed do
	(
		local bUpdate = false
	
		-- Check that base frame doesn't exceed the animation range
		if (spnBaseFrame.value < animationRange.start.frame) or (spnBaseFrame.value > animationRange.end.frame) do
		(
			messageBox "Base frame out of range!" title: "Warning"
			bUpdate = true
		)
	
		-- Check that start frame doesn't exceed the animation range
		if (spnStartFrame.value < animationRange.start.frame) or (spnStartFrame.value > animationRange.end.frame) do
		(
			messageBox "Start frame out of range!" title: "Warning"
			bUpdate = true
		)
	
		-- Check that end frame doesn't exceed the animation range
		if (spnEndFrame.value < animationRange.start.frame) or (spnEndFrame.value > animationRange.end.frame) do
		(
			messageBox "End frame out of range!" title: "Warning"
			bUpdate = true
		)
		
		-- If MAX animation range changes we have to update our sliders
		if bUpdate == true do
		(
			local start = animationRange.start.frame as Integer
			local end = animationRange.end.frame as Integer
	
			spnBaseFrame.range = spnStartFrame.range = spnEndFrame.range = [start, end, 0]
	
			spnBaseFrame.value = start
			spnStartFrame.value = start + 1
			spnEndFrame.value = end

			messageBox "Frame range configuration updated" title: "Info"
	
			return undefined
		)
	
		-- Is there some node to export?
		if lbxNodes.items.count <= 0 do
		(
			messageBox "Nothing to export!" title: "Warning"
			return undefined
		)
	
		-- Collect selected nodes
		local nodeList = #()
		for nodeName in lbxNodes.items do
		(
			node = getNodeByName nodeName
			append nodeList node
		)
	
		-- Export options
		case rdoOptions.state of
		(
			1:
			(
				-- Let the user select the md5mesh output file
				local meshFileName = getSaveFileName caption:"Save Doom III MD5Mesh" types:"Doom III MD5Mesh (*.md5mesh)|*.md5mesh"
	
				if meshFileName != undefined do
				(
					md5Exp = MD5MeshExporter()
					local bOk = md5Exp.doExport nodeList meshFileName
	
					if bOk == true do
						messageBox "MD5Mesh exported successfully!" title: ".::MD5Exporter::."
				)
			)
			2:
			(
				-- Let the user select the md5anim output file
				local animFileName = getSaveFileName caption:"Save Doom III MD5Anim" types:"Doom III MD5Anim (*.md5anim)|*.md5anim"
	
				if animFileName != undefined do
				(
					local nBaseFrame = spnBaseFrame.value
					local animRange = interval spnStartFrame.value spnEndFrame.value
	
					-- Create an ObjectSet
					clearSelection()
					for node in nodeList do
					(
						-- Increment the selection
						selectMore node
					)
	
					md5Exp = MD5AnimExporter()
					local bOk = md5Exp.doExport $selection nBaseFrame animRange animFileName
	
					if bOk == true do
						messageBox "MD5Anim exported successfully!" title: ".::MD5Exporter::."
	
					clearSelection()					
				)
			)
			3:
			(
				local bOk = false
	
				-- Let the user select the md5mesh output file
				local meshFileName = getSaveFileName caption:"Save Doom III MD5Mesh" types:"Doom III MD5Mesh (*.md5mesh)|*.md5mesh"
	
				if meshFileName != undefined do
				(
					-- Export!
					md5Exp = MD5MeshExporter()
					bOk = md5Exp.doExport nodeList meshFileName
	
					if bOk == false do
						messageBox "MD5Mesh export failed!" title: ".::MD5Exporter::."
				)
	
				-- If MD5Mesh was exported, go for MD5Anim
				if bOk == true do
				(
					-- Let the user select the md5anim output file
					local animFileName = getSaveFileName caption:"Save Doom III MD5Anim" types:"Doom III MD5Anim (*.md5anim)|*.md5anim"
	
					if animFileName != undefined do
					(
						local nBaseFrame = spnBaseFrame.value
						local animRange = interval spnStartFrame.value spnEndFrame.value
	
						-- Create an ObjectSet
						clearSelection()
						for node in nodeList do
						(
							-- Increment the selection
							selectMore node
						)
	
						-- Export!
						md5Exp = MD5AnimExporter()
						bOk = md5Exp.doExport $selection nBaseFrame animRange animFileName
	
						if bOk == true then
							messageBox "MD5Mesh and MD5Anim exported successfully!" title: ".::MD5Exporter::."
						else
							messageBox "MD5Anim export failed!" title: ".::MD5Exporter::."
	
						clearSelection()					
					)
				)
			)
		)
	)
)

rollout roMD5Camera ".::Camera::." width:160 height:378
(
	-- "Add" button filter function
	fn filterFn node =
	(
		return (superClassOf node == camera)
	)

	GroupBox grpCamera " Camera options " pos:[8,16] width:144 height:80
	label lblCamera "No camera selected" pos:[19,40] width:125 height:16
	pickbutton btnPick "Pick Camera" pos:[16,64] width:128 height:18 message:"Pick the camera to export" filter:filterFn

	GroupBox grpCutScenes " Cut scene options " pos:[8,112] width:144 height:208
	spinner spnStartFrame "Start " pos:[35,140] width:80 height:16 enabled:false type:#integer scale:1
	spinner spnEndFrame "End  " pos:[35,162] width:80 height:16 enabled:true type:#integer scale:1
	listbox lbxCuts "Cut scenes:" pos:[16,192] width:128 height:5
	button btnAdd "Add" pos:[17,288] width:60 height:18
	button btnRemove "Remove" pos:[82,288] width:60 height:18
	button btnExport "---> Export <---" pos:[32,344] width:96 height:18

	-- animationRange callback function
	fn roMD5Camera_updateFrames_cb =
	(
		-- New animation ranges
		local start = animationRange.start.frame as Integer
		local end = animationRange.end.frame as Integer

		-- When the spinners range changes, the values are reset to 0
		-- so save the current spinners values...
		local startFrame = spnStartFrame.value
		local endFrame = spnEndFrame.value

		-- Update spinners ranges
		spnStartFrame.range = spnEndFrame.range = [start, end, 0]

		-- Restore the previous values
		spnStartFrame.value = startFrame
		spnEndFrame.value = endFrame
	)

	on roMD5Camera open do
	(
		-- Init spinners
		local start = animationRange.start.frame as Integer
		local end = animationRange.end.frame as Integer
	
		spnStartFrame.range = spnEndFrame.range = [start, end, 0]

		spnStartFrame.value = 0
		spnEndFrame.value = end

		-- Register animationRange callback function
		registerTimeCallback roMD5Camera_updateFrames_cb
	)
	
	on roMD5Camera close do
	(
		-- Unregister animationRange callback function
		unRegisterTimeCallback roMD5Camera_updateFrames_cb
	)

	on btnPick picked node do
	(
		lblCamera.caption = node.name
	)

	on btnAdd pressed do
	(
		local range = interval spnStartFrame.value spnEndFrame.value
		local start = spnStartFrame.value

		-- Look if the range already exists
		local bFound = false
		if lbxCuts.items.count != 0 and (findItem lbxCuts.items (range as String) != 0) do
			bFound = true;

		if ( (spnEndFrame.value - start) > 0) and (bFound != true) then
		(
			-- Insert new interval
			lbxCuts.items += #(range as String)

			-- Now we have to update the start and end frame --
			if spnEndFrame.value < animationRange.end.frame do
			(
				-- Update start frame
				spnStartFrame.value = spnEndFrame.value + 1
				-- Update end frame
				if (spnEndFrame.value + 1) < animationRange.end.frame then
					spnEndFrame.value = spnEndFrame.value + 2
				else
					spnEndFrame.value = spnEndFrame.value + 1
			)
		)
		else
		(
			-- Too bad! :)
			if bFound == true then
				messageBox "Interval already in the list!" title: "Warning"
			else
				messageBox "Invalid range!" title: "Warning"
		)
	)
	on btnRemove pressed do
	(
		if (lbxCuts.items.count > 0) and (lbxCuts.selection > 0) do
		(
			-- Scene cuts must be deleted from bottom to top so if you want
			-- delete cut 4, you have to delete cuts 5, 6, etc. first.
			if lbxCuts.selection == lbxCuts.items.count then
			(
				-- Delete the selected cut
				deleteItem lbxCuts.items lbxCuts.selection
				lbxCuts.items = lbxCuts.items

				-- Now we have to update the start and end frame --
				if lbxCuts.items.count > 0 then
				(
					-- Get the last cut in the list
					local toks = filterString (lbxCuts.items[lbxCuts.items.count]) " ()f"
					local end = toks[3] as Integer
	
					-- Update start frame
					spnStartFrame.value = end + 1
					-- Update end frame
					if end <= animationRange.end.frame do
					(
						spnEndFrame.value = end + 2
					)
				)
				else
				(
					-- Update start frame
					spnStartFrame.value = 0
					-- Update end frame
					spnEndFrame.value = animationRange.end.frame
				)
			)
			else
			(
				messageBox "You have to delete cuts below the current cut first!" title: "Warning"
			)
		)
	)
	on btnExport pressed do
	(
		-- Is there some camera to export?
		local camera = getNodeByName lblCamera.caption
		if camera == undefined do
		(
			messageBox "No camera to export!" title: "Warning"
			return undefined
		)

		-- Is the camera animated?
		if camera.isAnimated == false do
		(
			messageBox "The selected camera is not animated!" title: "Warning"
			return undefined
		)

		-- Is there some cut scene to export?
		if lbxCuts.items.count == 0 do
		(
			messageBox "No cut scenes to export!" title: "Warning"
			return undefined
		)

		-- Check for invalid intervals
		local totalFrames = 0
		for auxCut in lbxCuts.items do
		(
			local toks = filterString auxCut " ()f"
			local start = toks[2] as Integer
			local end	= toks[3] as Integer

			totalFrames += (end - start + 1)
		)
		if totalFrames > (animationRange.end.frame - animationRange.start.frame + 1) do
		(
			messageBox "Invalid intervals found!" title: "Warning"
			return undefined
		)

		-- Export --

		-- Let the user select the md5mesh output file --

		local camFileName = getSaveFileName caption:"Save Doom III MD5Camera" types:"Doom III MD5Camera (*.md5camera)"

		if camFileName != undefined do
		(
			-- Note that MAXScript doesn't support extensions of 9 or more characters longer
			-- so we have to do a workaround here
			if (findString camFileName ".md5camera") == undefined do camFileName += ".md5camera"

			md5Exp = MD5CameraExporter()
			local bOk = md5Exp.doExport lbxCuts.items camera camFileName
	
			if bOk == true do
				messageBox "MD5Camera exported successfully!" title: ".::MD5Exporter::."
		)
	)
)


-- Let the show begins! :P --

if md5Exporter != undefined do
(
	closeRolloutFloater md5Exporter
)
md5Exporter = newRolloutFloater "MD5 Exporter" 172 580
addRollout roAbout md5Exporter
addRollout roMD5MeshAnim md5Exporter
addRollout roMD5Camera md5Exporter