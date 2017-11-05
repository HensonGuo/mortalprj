-- Developed by Jonathan "BeRSeRKeR" Garcia

fileIn "helper_funcs.ms"	-- helper functions

struct sJoint
(
	name,			-- name
	parentName,		-- parent name (if exists)
	parentIndex,	-- parent index (if exists)
	bindMat,		-- Absolute matrix
	invBindMat		-- Inverse of the absolute matrix
)
	
struct sVertex
(
	oldIndex,		-- index for weight calculation
	newIndex,		-- index of this vertex
	coord,			-- vertex coordinate
	texCoord,		-- texture coordinate
	weightIndex,	-- weight offset
	weightCount		-- weight count
)
			
struct sWeight
(
	jointIndex,		-- index of the bone for this weight
	weight,			-- weight value
	coordIndex,		-- index of the vertex in the list of vertices
	coord			-- weight coordinate (vertex offset)
)

struct sSubMesh
(
	matID,
	shader,
	vertices = #(),
	faces = #(),
	weights = #()
)

struct MD5MeshExporter
(
	-- Function: countSubMeshes
	-- Description: counts the number of submeshes to export
	-- Return: returns the number of submeshes to export
	fn countSubMeshes nodeList =
	(
		local nSubMeshes = 0
		for node in nodeList do
		(
			if classOf node.material != Multimaterial then
			(
				nSubMeshes += 1
			)
			else
			(
				local matIDs = #()
				local mesh = snapshotAsMesh node

				-- For each node face...
				for nFace = 1 to mesh.numFaces do
				(
					local matID = getFaceMatID mesh nFace
	
					-- Look if the matID already exists
					local bFound = false
					for nMatID = 1 to matIDs.count do
					(
						if matIDs[nMatID] == matID do
						(
							bFound = true
							exit
						)
					)
					if not bFound do
					(
						append matIDs matID
						nSubMeshes += 1
					)
				)
			)
		)
		return nSubMeshes
	),

	-- Function: collectSubMeshes
	-- Description: collects the submeshes to export
	-- Return: returns the submeshes array
	fn collectSubMeshes node mesh =
	(
		-- Collect required subMeshes
		local subMeshes = #()
		local nSubMeshes = 0
		-- If node material is not a Multimaterial only one mesh will exist
		if classOf node.material != Multimaterial then
		(
			append subMeshes (sSubMesh())
			nSubMeshes = 1
			subMeshes.shader = node.material.name
		)
		else	-- More than one mesh
		(
			-- For each node face...
			for nFace = 1 to mesh.numFaces do
			(
				local matID = getFaceMatID mesh nFace

				local bFound = false
				-- Look if the matID already exists
				for nSubMesh = 1 to nSubMeshes do
				(
					if subMeshes[nSubMesh].matID == matID do
					(
						bFound = true
						exit
					)
				)
				-- The matID didn't exist so add a new submesh
				if not bFound do
				(
					-- Append new submesh
					append subMeshes (sSubMesh())
					nSubMeshes += 1
					-- Submesh matID
					subMeshes[nSubMeshes].matID = matID

					-- Test the material availability
					if node.material[matID] != undefined then
					(
						-- The shader will be the name of the material
						subMeshes[nSubMeshes].shader = node.material[matID].name
					)
					else	-- Error
					(
						local msg = stringStream ""
						format "ERROR!: submaterial #% in node \"%\" not found" matID node.name to: msg
						messageBox (msg as String) title: ".::MD5Exporter::."
						close msg
						return undefined
					)
				)
			)
		)

		return subMeshes
	),

	-- Function: findSubMeshByMatID
	-- Description: find a submesh by its matID
	-- Return: returns the submesh index. If the submesh was not found, returns 0
	fn findSubMeshByMatID subMeshes matID =
	(
		local nSubMesh = 1
		for subMesh in subMeshes do
		(
			if subMesh.matID == matID do return nSubMesh
			nSubMesh += 1
		)
		return 0
	),

	-- Function: doExport
	-- Description: exports the bones in the scene and the nodes in "nodeList" to "fileName" file
	-- Return: returns true on success, otherwise returns false
	fn doExport nodeList fileName =
	(
		-- Create the md5mesh file to write in
		local fp = createFile fileName

		if fp == undefined do
		(
			local msg = stringStream ""
			format "ERROR!: couldn't create \"%\" file" fileName to: msg
			messageBox (msg as String) title: ".::MD5Exporter::."
			close msg
			return false
		)

		local joints = #()	-- List of bones
	
		-- Loop through each node in the scene
		for auxBone in $* do
		(
			-- Is the current node a bone?
			if ((classOf auxBone) == BoneGeometry) or ((classOf auxBone) == Biped_Object) do
			(
				-- Create a new bone
				joint = sJoint()

				-- Assign some useful data
				joint.name = auxBone.name
				joint.bindMat = toRightHanded auxBone.transform
				joint.invBindMat = inverse joint.bindMat

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

				-- Add the new joint to the list
				append joints joint
			)
		)
		-- Do parent/child relationship
		for b in joints do
		(
			if b.parentName != undefined do
				b.parentIndex = findBone joints b.parentName
		)

		-- Write md5mesh header --
	
		format "MD5Version 10\n" to: fp
		format "commandline \"\"\n\n" to: fp
		
		format "numJoints %\n" joints.count to: fp
		format "numMeshes %\n\n" (countSubMeshes nodeList) to: fp
	
		-- Write bone list --
	
		format "joints {\n" to: fp
		for j in joints do
		(
			local parentName = ""
			local pos = (roundNearZero j.bindMat.row4)
			local q = (roundNearZero (j.bindMat as Quat))
			if q.w < 0 do
			(
				q.x = -q.x
				q.y = -q.y
				q.z = -q.z
			)
			if j.parentName != undefined do parentName = j.parentName
			format "\t\"%\"\t% ( % % % ) ( % % % )\t\t// %\n" j.name (j.parentIndex-1) pos.x pos.y pos.z q.x q.y q.z parentName to: fp
		)
		format "}\n\n" to: fp

		-- Now we're gonna collect the necessary data for each mesh to export --

		for node in nodeList do
		(
			local subMeshes = #()	-- List of submeshes

			-- Take a snapshot of the current mesh
			local mesh = snapshotAsMesh node
		
			-- Set modify mode
			max modify mode
			-- Reference to the skin modifier for this mesh
			skin = node.modifiers[#Skin]
			-- Look if the skin modifier exists
			if skin == undefined do
			(
				local msg = stringStream ""
				format "ERROR!: no skin modifier for \"%\"" node.name to: msg
				messageBox (msg as String) title: ".::MD5Exporter::."
				close msg
				close fp
				return false
			)
			-- Enable skin modifier in the modifiers panel
			modPanel.setCurrentObject skin

			-- Collects submeshes
			subMeshes = collectSubMeshes node mesh

			-- Error. No submeshes found
			if subMeshes == undefined do
			(
				close fp
				return false
			)

			-- Collect vertices, tris and weights...
			for nFace = 1 to mesh.numFaces do
			(
				-- Find working submesh
				local nSubMesh = 1
				local matID = getFaceMatID mesh nFace
				if subMeshes.count > 1 then
					nSubMesh = findSubMeshByMatID subMeshes matID

				-- References to submesh data
				local vertices = subMeshes[nSubMesh].vertices
				local faces = subMeshes[nSubMesh].faces
				local weights = subMeshes[nSubMesh].weights

				-- Reference to current face vertex & texture coordinate
				vTri = getFace mesh nFace
				tTri = getTVFace mesh nFace

				-- Resulting face of the process
				local outFace = Point3 0 0 0

				-- For each face index...
				for i = 1 to 3 do
				(
					-- Resulting vertex of the process
					local outVert = sVertex()

					-- Reference to the MAX vertex coordinate
					local inVert = getVert mesh vTri[i]
					-- Reference to the MAX texture coordinate
					local inTVert = getTVert mesh tTri[i]
					inTVert = Point2 inTVert.x inTVert.y
		
					-- Now we have to see if the current vertex already exists in the final list of vertices
					local firstMatch = 0
					for v in vertices do
					(
						-- Increment first match of the current vertex counter
						firstMatch += 1
		
						-- Did we found the first match of the current vertex?
						if (v.coord == inVert) and (outVert.oldIndex == undefined) do
						(
							-- Yes!. So store its value.
							-- We're gonna make use of this later for weight calculation!
							outVert.oldIndex = firstMatch
						)
		
						-- Did we found a vertex equal in vertex & texture coordinates?
						if (v.coord == inVert) and (v.texCoord == inTVert) do
						(
							-- Yes. So we assign the index of the located vertex
							outVert.newIndex = v.newIndex
						)
					)
		
					-- Time for weight calculation --
					
					-- If the vertex already exists means we don't need to add a new weight.
					-- We have to use the located vertex weight instead
					if outVert.oldIndex != undefined then
					(
						-- Assign weight index (offset) and count
						outVert.weightIndex = vertices[outVert.oldIndex].weightIndex
						outVert.weightCount = vertices[outVert.oldIndex].weightCount
					)
					else
					(
						-- The vertex didn't exist so we have to add a new weight
		
						-- Bones that affect the current vertex
						local nBones = skinOps.getVertexWeightCount skin vTri[i]
		
						-- Assign weight offset
						outVert.weightIndex = weights.count + 1
						-- Assign weight count starting on "weightIndex"
						outVert.weightCount = nBones
		
						-- Loop through each bone that affect the current vertex
						for nBone = 1 to nBones do
						(
							-- Bone ID (Note that this is not the real bone ID we have to export!)
							local boneID = skinOps.getVertexWeightBoneID skin vTri[i] nBone
							-- Weight of the vertex for the current bone
							local weight = skinOps.getVertexWeight skin vTri[i] nBone
		
							-- Calculate the real bone ID
							local boneName = skinOps.getBoneName skin boneID 0
							local realBoneID = findBone joints boneName

							-- Create the new weight and assign values
							w = sWeight()
							w.jointIndex = realBoneID
							w.coordIndex = vertices.count + 1
							w.weight = weight

							-- Add the new weight to the list of weights
							append weights w
						)
					)
		
					-- Did the current vertex already exists in the list of vertices?
					if outVert.newIndex == undefined then
					(
						-- No. So we have to create a new vertex
						outVert.coord = inVert
						outVert.texCoord = inTVert
						outVert.newIndex = vertices.count + 1
		
						-- Add the new vertex to the list of vertices
						append vertices outVert
		
						-- Index for this vertex
						outFace[i] = vertices.count
					)
					else
					(
						-- The vertex already exists so the only thing we have to do is add its index
						outFace[i] = outVert.newIndex
					)
				)

				-- Add the new face to the list of faces
				append faces outFace
			)
			
			-- Write mesh data --
		
			for subMesh in subMeshes do
			(
				-- References to submesh data
				local shader = subMesh.shader
				local vertices = subMesh.vertices
				local faces = subMesh.faces
				local weights = subMesh.weights

				format "mesh {\n" to: fp
					format "\t// meshes: %\n" node.name to: fp
					format "\tshader \"%\"\n\n" shader to: fp
	
					-- Write vertices
					format "\tnumverts %\n" vertices.count to: fp
					for i = 1 to vertices.count do
					(
						v = vertices[i]
						format "\tvert % ( % % ) % %\n" (i-1) (roundNearZero v.texCoord.x) (roundNearZero (1-v.texCoord.y)) (v.weightIndex-1) v.weightCount to: fp
					)
	
					-- Write faces
					format "\n\tnumtris %\n" faces.count to: fp
					for i = 1 to faces.count do
					(
						f = faces[i]
						format "\ttri % % % %\n" (i-1) ((f.x-1) as Integer) ((f.z-1) as Integer) ((f.y-1) as Integer) to: fp
					)
	
					-- Write weights
					format "\n\tnumweights %\n" weights.count to: fp
					for i = 1 to weights.count do
					(
						w = weights[i]
						offset = roundNearZero (vertices[w.coordIndex].coord * joints[w.jointIndex].invBindMat)
						format "\tweight % % % ( % % % )\n" (i-1) (w.jointIndex-1) (roundNearZero w.weight) offset.x offset.y offset.z to: fp
					)
				format "}\n\n" to: fp
			)

			-- Call the garbage collector
			gc()
		)

		-- Clear MAX selection
		clearSelection()

		-- Close the output file
		close fp

		-- Alright!
		return true
	)
)