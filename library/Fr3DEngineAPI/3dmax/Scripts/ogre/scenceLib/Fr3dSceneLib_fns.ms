include "ogre/MD5Exporter/helper_funcs.ms"
include "ogre/pcloudLib/OgrePcLibFuns.ms"
include "ogre/lib/OgreSkeletonLib_usefulfns.ms"


function doesVertexExistAlready2 dataTable newTable vertexIndex vertexNormal uv useNormal =
(
	--format "vertex a tester % % \n" vertexIndex vertexNormal;
	newVertexIndex=newTable[vertexIndex];
	if (newVertexIndex==undefined) then
	(
		return 0;
	)
	data=dataTable[newVertexIndex];
	if(data[2]!=uv) then
	(
		return 0;
	) 
	if(useNormal and data[3]!=vertexNormal) then 
	(
		return 0;
	)
	return newVertexIndex;
)
function getVertexAndFaceIndex nodeObj tmesh tableMap vertexIndexList hasNormal=
(
	numFaces = (getNumFaces tmesh);
	--nodeTransform=toLeftHanded nodeObj.transform
	nodeTransform=nodeObj.transform
	invNodedMat=inverse nodeTransform;

	local preMatId=-16;
	local searchTable=#();
	for face = 1 to numFaces do 		-- LOOP on FACES --
	(	
		faceVerticesIndices = getFace tmesh face ;
		faceUVIndices = getTVFace tmesh face ;
		matId = getFaceMatId tmesh face ;
		if(preMatId!=-16 and preMatId!=matId ) then
		(
			--messagebox "不支持多维材质";
			--return false;
		)
		preMatId=matId;
		numVertex = (getNumVerts tmesh);
		
		for localVertexIndex=1 to 3 do 				-- LOOP on VERTICES --
		(	
			vertexIndex = (int) (faceVerticesIndices[localVertexIndex]) ;

			vertexNormal = getVertexNormalAccordingToSmoothingGroups tmesh face localVertexIndex;
			
			uv=getTVert tmesh faceUVIndices[localVertexIndex]
			
			targetVertexIndex=doesVertexExistAlready2 tableMap searchTable vertexIndex vertexNormal uv hasNormal;
			
			if(targetVertexIndex==0) then
			(
				data=#();
				vertexPosition = getVert tmesh faceVerticesIndices[localVertexIndex];
				vertexPosition=vertexPosition*invNodedMat;
				append data vertexPosition
				
				append data uv
				
				append data vertexNormal

				append tableMap data
				searchTable[vertexIndex]= tableMap.count;
				
				append vertexIndexList tableMap.count;
			)else
			(
				append vertexIndexList targetVertexIndex;
			)
		)
	)
	return true;
	
)
function exportObjectAnimate sceneFile nodeObj blank =
(
	animNames=getObjectSeting nodeObj "objAnimate" "anims_names" true
	startframes=getObjectSeting nodeObj "objAnimate" "anims_startframes" true
	endframes=getObjectSeting nodeObj "objAnimate" "anims_endframes" true
	lengths=getObjectSeting nodeObj "objAnimate" "anims_lengths" true
	types=getObjectSeting nodeObj "objAnimate" "anims_types" true
	format("%<animate>\n") blank to:sceneFile ;
	len=animNames.count;
	
	for i=1 to len do
	(
		aname=animNames[i];
		astart=startframes[i];
		aend=endframes[i];
		alen=1;
		atype=animateTypeArr[types[i]];
		if(atype == "(挂载)动画") then
		(
			format("%\t<track name=\"%\" targetMesh=\"%\" targetBone=\"%\" type=\"%\"/>\n") blank aname astart aend atype to:sceneFile ;
			continue;
		)else if(atype !="(位移+旋转+缩放)动画") then 
		(
			continue;
		)
		format("%\t<track name=\"%\" start=\"%\" end=\"%\" len=\"%\" type=\"%\">\n") blank aname astart aend alen atype to:sceneFile ;
		keys=#();
		keyindex=#();
		local curNum=0;
		for f=astart to aend by alen do 
		(
			at time f
			(
				append  keys (getTransformData nodeObj false)
				append keyindex f;
			)
			curNum=f;
		)
		if(curNum!=aend) then
		(
			f=aend;
			at time f
			(
				append  keys (getTransformData nodeObj false)
				append keyindex f;
			)
		)
		num=keys.count;
		for f=1 to num do
		(
			str=keys[f];
			format("%\t\t<key index=\"%\" value=\"%\"/>\n") blank keyindex[f] keys[f] to:sceneFile ;
		)
		format("%\t</track>\n") blank to:sceneFile;
	)
	
	format("%</animate>\n") blank to:sceneFile ;
	
)
function impWriteMesh f hasNormal vertexNum faceNum tableMap vertexIndexList indexDirection =
(
	if(hasNormal==false) then
	(
		
		for i=1 to vertexNum do
		(
			data=tableMap[i];
			pos=data[1];
			writefloat f pos.x
			writefloat f pos.z
			writefloat f pos.y
			
			uv=data[2];
			writefloat f uv.x
			writefloat f (1-uv.y)
		)
	)else 
	(
		for i=1 to vertexNum do
		(
			data=tableMap[i];
			pos=data[1];
			writefloat f pos.x
			writefloat f pos.z
			writefloat f pos.y
			
			uv=data[2];
			writefloat f uv.x
			writefloat f (1-uv.y)
			
			pos=data[3];
			writefloat f pos.x
			writefloat f pos.y
			writefloat f pos.z
		)
	)
	
	if(indexDirection>0) then
	(
		for i=1 to faceNum do
		(
			n=i-1;
			face_i=vertexIndexList[n*3+1]-1;
			writeshort f face_i #unsigned
			
			face_i=vertexIndexList[n*3+3]-1;
			writeshort f face_i #unsigned
			
			face_i=vertexIndexList[n*3+2]-1;
			writeshort f face_i #unsigned
		)
	)else
	(
		for i=1 to faceNum do
		(
			n=i-1;
			face_i=vertexIndexList[n*3+1]-1;
			writeshort f face_i #unsigned
			
			face_i=vertexIndexList[n*3+2]-1;
			writeshort f face_i #unsigned
			
			face_i=vertexIndexList[n*3+3]-1;
			writeshort f face_i #unsigned
		)
	)
)

function exportMesh nodeObj tmesh meshFileUrl hasNormal matName =
(
	_material = nodeObj.material ;
	answer = "OK" ;
	if (_material == undefined) then
	(
		answer = "the mesh : \""+nodeObj.name+"\" doesn't have any material, please apply one\n" ;
	)else if (getNumTVerts tmesh == 0) then
	(
		answer = "the mesh : \""+nodeObj.name+"\" must have UVW coords in order to be exported" ;
	)
	
	if(answer !="OK") then
	(
		messagebox answer;
		return false;
	)
	local tableMap=#();
	local vertexIndexList=#();
	
	getVertexAndFaceIndex nodeObj tmesh tableMap vertexIndexList hasNormal;
	
	f=fopen meshFileUrl "wb"
	magic=0x1000
	version=1
	vertexNum=tableMap.count;
	faceNum=vertexIndexList.count/3;
	if(hasNormal==true) then
	(
		hasNormalValue=1;
	)else
	(
		hasNormalValue=0;
	)
	
	writeshort f magic #unsigned
	writeshort f version #unsigned
	writeString f nodeObj.name
	writeString f matName
	writebyte f hasNormalValue
	writeshort f vertexNum #unsigned
	writeshort f faceNum #unsigned

	indexDirection=nodeObj.scale.x*nodeObj.scale.y*nodeObj.scale.z
	impWriteMesh f hasNormal vertexNum faceNum tableMap vertexIndexList indexDirection;

	fclose f
	return true;
)

function impWriteNodeToScene nodeObj sceneFile exportFolder blank exportNormal exportMeshFile =
(
	local exportingMeshDone=true;
	local meshName=getObjectMeshFileUrl nodeObj ".mesh"
	local meshFileName=exportFolder+meshName
	
	local mat=nodeObj.material;
	local matName="Null";

	if(mat!=undefined) then
	(
		matname = replaceSpaces mat.name;
	)
	animsTypes=getObjectSeting nodeObj "objAnimate" "anims_types" true;

	if( iskindof nodeObj GeometryClass ) then
	(
		if(iskindOf nodeObj pcloud) then
		(
			format("%<node name=\"%\" type=\"pcloud\" meshFile=\"%\" material=\"%\">\n") blank nodeObj.name meshName matName to:sceneFile ;
			if(exportMeshFile) then
			(
				exportingMeshDone = impExportPcload nodeObj meshFileName;
			)
			
		)else if(iskindOf nodeObj plane) then
		(
			
			format("%<node name=\"%\" type=\"plane\" width=\"%\" height=\"%\" material=\"%\">\n") blank nodeObj.name nodeObj.width nodeObj.length matName to:sceneFile ;
		)else if(iskindOf nodeObj box) then
		(
			format("%<node name=\"%\" type=\"box\" width=\"%\" height=\"%\" material=\"%\">\n") blank nodeObj.name nodeObj.width nodeObj.length matName to:sceneFile ;
		)else
		(
			tmesh = snapshotAsMesh nodeObj ;
			if(tmesh==undefined) then 
			(
				print nodeObj.name
			)
			numFaces = (getNumFaces tmesh);
			
			
			if( (isSkinMesh nodeObj)==true and (hasTargetTypeAnimate animsTypes "(骨骼)动画" ) ) then
			(
				format("%<node name=\"%\" type=\"skinMesh\" faceNum=\"%\" meshFile=\"%\" material=\"%\">\n") blank nodeObj.name numFaces meshName matName to:sceneFile ;
				if(exportMeshFile) then
				(
					exportingMeshDone = md5MeshExp.doExport #(nodeObj) meshFileName
				)
				
			)else
			(
				format("%<node name=\"%\" type=\"mesh\" faceNum=\"%\" meshFile=\"%\" material=\"%\">\n") blank nodeObj.name numFaces meshName matName to:sceneFile ;
				if(exportMeshFile) then
				(
					exportingMeshDone = exportMesh nodeObj tmesh meshFileName exportNormal matName;
				)
				
			)
				
			
			
		)
	)else
	(
		format("%<node name=\"%\" type=\"container\">\n") blank nodeObj.name to:sceneFile ;
	)
	data2=getTransformData nodeObj false
	
	format("%\t<matrix3 value=\"%\"/>\n") blank data2 to:sceneFile ;
	
	userdata=getObjectSeting nodeObj "objAnimate" "userData" false;
	
	if(userdata.count >0 ) then
	(
		userdata=replaceStr userdata "\n" "|"
		format("%\t<userData><![CDATA[%]]></userData>\n") blank userdata to:sceneFile ;
	)
	
	hasNodeAnimate=hasTargetTypeAnimate animsTypes "(位移+旋转+缩放)动画"
	hasBonePointAnimate=hasTargetTypeAnimate animsTypes "(挂载)动画"
	hasSkeletonAnimate=hasTargetTypeAnimate animsTypes "(骨骼)动画"
	if(hasNodeAnimate or hasBonePointAnimate ) then
	(
		exportObjectAnimate sceneFile nodeObj (blank+"\t")
	)
	
	if( hasSkeletonAnimate==true and exportMeshFile==true) then
	(
		nBaseFrame = animationRange.start.frame;
		animFileUrl = exportFolder + (getObjectMeshFileUrl nodeObj ".skeleton")
		md5AnimExp.doExport nodeObj nBaseFrame animFileUrl;
	)
)


function writeNodeToScene nodeObj sceneFile exportFolder blank exportNormal exportMeshFile =
(
	needExport=checkNeedToWrite nodeObj
	if( needExport ==true ) then
	(
		impWriteNodeToScene nodeObj sceneFile exportFolder blank exportNormal exportMeshFile;
	)
	arr=nodeObj.children
	len=arr.count;
	for i=1 to len do
	(
		obj=arr[i]
		writeNodeToScene obj sceneFile exportFolder (blank+"\t") exportNormal exportMeshFile;
	)
	if(needExport==true) then
	(
		format("%</node>\n") blank to:sceneFile ;
	)
	
	return exportingMeshDone ;
)



function exportScene sceneObjects exportNormal exportMeshFile =
(
	local rootList=#();
	len=sceneObjects.count
	for i=1 to len do
	(
		obj=sceneObjects[i];
		if( obj.parent==undefined  ) then 
		(
			append rootList obj
		)
	)
	len=rootList.count;
	local outFile;
	if( len >0 ) then
	(
		outName=(getInit "Settings" "sceneExportFolderUrl")+(replaceStr maxFileName ".max" ".scene")
		if (g_MAX) then
		(
			ClearListener();
			if (g_MAX_use_listener) then
				format("<ogrestartfile>%</ogrestartfile><ogrestartdata>\n") outName;
			outFile = listener;
		)
		else
		(
			outFile = createfile outName;
		)
		format("<?xml version=\"1.0\" encoding=\"gb2312\"?>\n") to:outFile ;
		format("<scene>\n\t<nodes>\n") to:outFile ;

	)
	local exportFolder=getInit "Settings" "sceneExportFolderUrl"
	for i=1 to len do
	(
		obj=rootList[i];
		success=writeNodeToScene obj outFile exportFolder "\t\t" exportNormal exportMeshFile;
	)
	if(len >0 ) then
	(
		format("\t</nodes>\n</scene>") to:outFile ;
		if (not g_MAX) then
		(
			close outFile ;
		)	
	)
	return true
)

