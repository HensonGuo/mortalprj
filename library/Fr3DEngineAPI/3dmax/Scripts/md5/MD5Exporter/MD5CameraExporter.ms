-- Developed by Jonathan "BeRSeRKeR" Garcia

fileIn "helper_funcs.ms"	-- helper functions

struct MD5CameraExporter
(
	fn doExport cutList camera fileName =
	(
		local tokens = undefined

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

		-- Get the first and last cut in the list
		tokens = filterString cutList[1] " ()f"
		local start = tokens[2] as Integer
		tokens = filterString cutList[cutList.count] " ()f"
		local end = tokens[3] as Integer

		-- Number of frames
		local numFrames = (end - start + 1) as Integer
		-- Frame rate
		local fps = frameRate	

		-- Write md5mesh header --

		format "MD5Version 10\n" to: fp
		format "commandline \"\"\n\n" to: fp
	
		format "numFrames %\n" numFrames to: fp
		format "frameRate %\n" fps to: fp

		if cutList.count > 1 then
			format "numCuts %\n\n" (cutList.count - 1) to: fp
		else
			format "numCuts %\n\n" 0 to: fp

		-- Write cut scenes --

		if cutList.count > 1 do
		(
			format "cuts {\n" to: fp
			for nCut = 1 to (cutList.count - 1) do
			(
				tokens = filterString cutList[nCut + 1] " ()f"
				format "\t%\n" (((tokens[2] as Integer) - 1) as String) to: fp
			)
			format "}\n\n" to: fp
		)
		

		-- Write animation keys --

		format "camera {\n" to: fp
		for nFrame = start to end do
		(
			at time nFrame
			(
				-- Thanks to der_ton for this one
				transform = Matrix3 1
				transform[1] = -camera.transform[3]
				transform[2] = -camera.transform[1]
				transform[3] =  camera.transform[2]
				transform[4] =  camera.transform[4]

				local pos = roundNearZero transform.row4
				local rot = roundNearZero (normalize transform.rotationPart)
				local fov = roundNearZero camera.fov

				if rot.w < 0 do
				(
					rot.x = -rot.x
					rot.y = -rot.y
					rot.z = -rot.z
				)

				format "\t( % % % ) ( % % % ) %\n" pos.x pos.y pos.z rot.x rot.y rot.z fov to: fp
			)
		)
		format "}\n\n" to: fp

		-- Close the output file
		close fp

		-- Alright!
		return true
	)
)