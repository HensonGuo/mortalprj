----------------------------------------------------------------------------------------
-- ------------------------------ SOME USEFUL FUNCTIONS ----------------------------- --
----------------------------------------------------------------------------------------

-- global variables
global g_MAX = false;
global g_MAX_use_listener = false;
global enabledArr;
global animateTypeArr;
global md5MeshExp;
global md5AnimExp;
global curSelectObject;

-- global structures
struct exportOptions (sampleRate, ikSampleRate, scale, flipyz, flipNormal, exportColours, exportUV, UVchannels);
struct exportAnims (names, startframes, endframes, lengths) ;

global Options;

global OgreExportFloater;
global OgreExportOptions, OgreExportObject, OgreExportMesh, OgreExportAnimation, OgreExportMaterial, OgreExportAbout;

--------------------------------------------------------------------
-- compute the transform, if you want to flip Y and Z axis,
-- because the axis which 'defines height' in OGRE is the Y axis,
-- whereas 3dsmax uses the Z one.
--------------------------------------------------------------------
function flipYZTransform Tform = (
	local axis1,axis2,axis3,t,m
	
	-- computes the matrix
	axis1 = point3 1 0 0 ;
	axis2 = point3 0 0 1 ;
	axis3 = point3 0 -1 0 ;
	t = point3 0 0 0 ;
	m=matrix3 axis1 axis2 axis3 t ;
	
	-- multiplies by the inverse
	Tform = Tform*inverse(m) ;

	return Tform ;
)

function hasTargetTypeAnimate typeArr type =
(
	len=typeArr.count;
	for i=1 to len do
	(
		if( animateTypeArr[typeArr[i]]==type ) then
		(
			return true;
		)
	)
	return false;
)
function checkNeedToWrite obj =
(
	if( (iskindof obj BoneGeometry) or (iskindOf obj Biped_Object)) then
	(
		--骨骼对像
		return false;
	)
	
	hasChildren=obj.children.count > 0 ;
	toWrite=false;
	if( iskindof obj GeometryClass ) then
	(
		tmesh = snapShotAsMesh obj
		if(tmesh==undefined) then
		(
			return false;
		)
		objIsEmpty=( (getNumFaces tmesh)==0  and hasChildren);
		isPcloud=iskindOf obj pcloud
		delete tmesh ;
		if( objIsEmpty and (not isPcloud) ) then
		(
			--空对像
			return false;
		)else
		(
			return true;
		)
	)else if(iskindof obj Helper) then
	(
		return true;
	)
	return false;
)
function getTransformData targetNode toArray =
(
	if(targetNode.parent != undefined ) then
	(
		matRelative = targetNode.parent.transform
		matRelative = inverse matRelative
		matRelative = targetNode.transform * matRelative
	)else
	(
		matRelative =copy targetNode.transform
		
	)
	--matRelative=toLeftHanded matRelative
	--matRelative=inverse matRelative;

	v1=roundNearZero matRelative.row1
	v2=roundNearZero matRelative.row2
	v3=roundNearZero matRelative.row3
	v4=roundNearZero matRelative.row4
	
	if(toArray==true) then
	(
		str=#(v1.x,v1.y,v1.z,v2.x,v2.y,v2.z,v3.x,v3.y,v3.z,v4.x,v4.y,v4.z);
	)else
	(
		str=(v1.x as String)+","+(v1.y as String)+","+(v1.z as String);
		str=str+","+(v2.x as String)+","+(v2.y as String)+","+(v2.z as String);
		str=str+","+(v3.x as String)+","+(v3.y as String)+","+(v3.z as String);
		str=str+","+(v4.x as String)+","+(v4.y as String)+","+(v4.z as String);
	)
	return str
)
function isSkinMesh targetNode = (
	isSkin = ( (getSkin targetNode) != undefined  and (skinOps!=undefined) );
	isPhy = ( (getPhysique targetNode) != undefined and (physiqueOps!=undefined) );
	return (isSkin or isPhy)
)
function getOjbectIndex targetNode = (
	if(targetNode==undefined) then
	(
		messagebox "出错了，物体为空";
		return 0;
	)
	idStr=getUserProp targetNode "nodeId"
	if(idStr==undefined) then
	(
		idStr=getInit "Settings" "lastIndex"
		setUserProp targetNode "nodeId" idStr
		id=idStr as Number
		id=id+1;
		setInit "Settings" "lastIndex" id
	)
	return idStr
	
)
function getObjectMeshFileUrl targetNode type= (
	objIndex=getOjbectIndex targetNode
	meshName=(objIndex as String)+"_"+targetNode.name+type
	return  meshName
)

function setObjectSeting targetNode type1 type2 value = (
	id=getOjbectIndex targetNode
	idstr=id as String
	setInit (type1+"_"+idstr) type2 value
)
function getObjectSeting targetNode type1 type2 isArray = (
	id=getOjbectIndex targetNode
	idstr=id as String
	resultValue=getInit (type1+"_"+idstr) type2
	if(isArray and resultValue == "") then
	(
		return #()	
	)
	return resultValue
)
function getInit type1 type2 =(
	configUrl=getMaxFileUrl()
	str=getINISetting configUrl type1 type2
	str=replaceStr str "<->" "\n"
	if( (findString str "#(") != undefined) then
	(
		arr=execute str
		return arr;
	)
	
	return str;
)
function setInit type1 type2 values =(
	configUrl=getMaxFileUrl();
	str=(values as String)
	str=replaceStr str "\n" "<->"
	setINISetting configUrl type1 type2 str
)
function getMaxFileUrl = (
	local configUrl
	if(maxFilePath == "") then
	(
		configUrl=(getDir #scripts)+"\\ogre\\tempConfig.ini"
	)else
	(
		configUrl=maxFilePath+(replaceStr maxFileName ".max" "_config.ini")
		if (not (doesFileExist configUrl)) then
		(
			copyFile ((getDir #scripts) + "\\ogre\\ogreScript.ini") configUrl
			len=objects.count
			for i=1 to len do
			(
				setUserProp objects[i] "nodeId" (i as String)
			)
			setInit "Settings" "lastIndex" (len+1)
		)
	)
	return configUrl ;
)
-----------------------------------------------------------------------------
-- check if the bone is the root object of the biped
-----------------------------------------------------------------------------
function checkEnabled arr =
(
	local len;
	if(arr==undefined) then
	(
		len=0;
	)else
	(
		len=arr.count
	)
	if(curSelectObject!=undefined) then
	(
		for i=1 to len do
		(
			if(arr[i]!=undefined) then
			(
				arr[i].enabled=true;
			)
			
		)
		return true;
	)else
	(
		for i=1 to len do
		(
			if(arr[i]!=undefined) then
			(
				arr[i].enabled=false;
			)
		)
		return false;
	)
)
function isPelvis bipObj =
(
	if (bipObj == undefined) then return false ;
	if (classof bipObj != Biped_Object) then return false;
	return ((biped.getNode bipObj 13) == bipObj) ;
)


-----------------------------------------------------------------------------
-- check if the bone is the footstep object of the biped
-----------------------------------------------------------------------------
function isFootStep bipObj =
(
	if (bipObj == undefined) then return false ;
	if (classof bipObj != Biped_Object) then return false;
	return ((biped.getNode bipObj 16) == bipObj) ;
)


--------------------------------------------------------------------
-- returns if the bone is the root or not,
-- ia if its parent is undefined or is not a bone.
--------------------------------------------------------------------
function isRoot b = (
	if (b.parent==undefined or not (iskindof b.parent BoneGeometry or iskindOf b.parent Biped_Object) ) then
		return true ;
	else
		return false ;
	
)

--------------------------------------------------------------------
-- returns if the bone is the root or not,
-- handles standard bones as well as biped
--------------------------------------------------------------------
function isRootUniversal b = (
	if (isRoot b) then
		return true; 
	else if (isPelvis b) then
		return true;
	else
		return false;
)

--------------------------------------------------------------------
-- returns if the object is a root or not,
-- handles any kind oj object
--------------------------------------------------------------------
function isRootUniversal2 b = (
	bname = replaceSpaces b.name;
	ind = (findItem RootsList bname);
	if (ind == 0) then
		return false;
	else
		return true;
)

--------------------------------------------------------------------
-- returns if the object is part of the skin (or physique modifier)
--------------------------------------------------------------------
function isPartOfModifier b sk phy = (
	name = replaceSpaces b.name ;
	if (sk!=undefined and skinOps!=undefined) then
	(
		for i=1 to (skinOps.GetNumberBones sk) do
		(
			bname = skinOps.GetBoneName sk i 1 ;
			replaceSpaces bname ;
			if (name == bname) then
				return true;
		)
	)
	else if (phy!=undefined and physiqueOps!=undefined) then
	(
		for i=1 to (physiqueOps.GetBoneCount $) do
		(
			bname = (physiqueOps.GetBones $)[i].name;
			replaceSpaces bname ;
			if (name == bname) then
				return true;
		)
	)
	return false;
)

--------------------------------------------------------------------
-- creates a new array (which must be set up as an array before
-- calling this function) in which there isn't the same element.
-- Moreover, the array is sorted.
--------------------------------------------------------------------

function keepLoneValues a b= (
	local e, last_e ;
	sort a ;
	last_e = undefined ;
	for e in a do (
		if (e!=last_e) then 
			append b e ;
		last_e = e ;
	)
)

---------------------------------------------------------------------
-- replaces " " by "_" in a string.
-- when a name is for example Left Biceps max knows it at Left_Biceps
-- and execute function will not work if you don't use this function
---------------------------------------------------------------------
function replaceSpaces s =
(
	return (replaceStr s " " "")
)

function replaceStr s flag toFlag =
(
	result=copy s
	num=s.count
	len2=flag.count
	for i=1 to num do
	(
		index=findString result flag
		if ( index == undefined ) then
		(
			exit
		)else
		(
			result =replace result index len2 toFlag;
		)
			
	)
	return result ;
)

function getFolderUrl s =
(
	local len=s.count
	local j=len
	for i=1 to len do
	(
		j=len-i
		if (s[j] == "\\" or s[j] == "\/") then 
		(
			exit
		)	
	)
	s=substring s 1 j
	return s ;
)
--------------------------------
-- return the length of an array
--------------------------------
function arrayLength a = 
(
	local i ;
	i = 1 ;
	while (a[i] != undefined) do
		i = i + 1 ;	
	i-1 ;
)

-----------------------------------------------------------------------------
-- return the skin modifier or undefined if object don't have a skin modifier
-----------------------------------------------------------------------------
function getSkin obj =
(
	local s,i ;
	s = undefined ;
	if obj != undefined then
		for i in obj.modifiers do
		(
			if iskindof i Skin do
				s = i ;
		)
	s ;
)


-----------------------------------------------------------------------------
-- return the physique modifier or undefined if object don't have it
-----------------------------------------------------------------------------
function getPhysique obj =
(
	local s,i ;
	s = undefined ;
	if obj != undefined then
		for i in obj.modifiers do
		(
			if iskindof i Physique do
				s = i ;
		)
	s ;
)

-----------------------------------------------------------------------------
-- return the OctopusExport modifier or undefined if object don't have it
-----------------------------------------------------------------------------
function getOctopusExport obj =
(
	local s,i ;
	s = undefined ;
	if obj != undefined then
		for i in obj.modifiers do
		(
			if iskindof i OctopusMeshModifier do
				s = i ;
		)
	s ;
)

--------------------------------------------------
-- return an Array with the root bones of the skin
--------------------------------------------------

function getRoots skin =
(
	local rootstab,n,i,c,d ;
	rootstab = #() ;
	n = skinOps.GetNumberBones skin ;
	for i = 1 to n do
	(
		c= skinOps.GetBoneName skin i 1 ;
		replaceSpaces c ;
		d = getNodeByName c ;
		if (isRoot d) then
			append rootstab d ;
	)
	rootstab ;
)

--------------------------------------------------------
-- return an Array with the ID of root bones of the skin
--------------------------------------------------------

function getRootsId skin =
(
	local rootstab,n,i,c,d ;
	rootstab = #() ;
	n = skinOps.GetNumberBones skin ;
	for i = 1 to n do
	(
		c= skinOps.GetBoneName skin i 1 ;
		replaceSpaces c ;
		d = getNodeByName c ;
		if (isRoot d) then
			append rootstab i ;
	)
	rootstab ;
)

-------------------------------------------------------
-- return a angleAxis given a Quaternion
-------------------------------------------------------

function toAngleAxis q =
(
	local angle, axis;
	local result;
	
	fSqrLength = q.x*q.x+q.y*q.y+q.z*q.z ;
	if (fSqrLength > 0.0) then
	(
		angle = ((acos q.w) * pi / 90);
		fInvLength = 1.0 / (sqrt fSqrLength);
		axis = [q.x*fInvLength, q.y*fInvLength, q.z*fInvLength];
		result = angleAxis angle axis;
	)
	else
	(
		angle = 0;
		axis = [1,0,0];
		result = angleAxis angle axis;
	)
	
	return result;
)

function checkAnimateType obj targetRollOut curSelectType =
(
	if(curSelectType=="(顶点)动画") then
	(
		targetRollOut.SampleTime.enabled=true;
	)else
	(
		targetRollOut.SampleTime.value=1;
		targetRollOut.SampleTime.enabled=false;
	)
	
	if(curSelectType =="(挂载)动画") then
	(
		targetRollOut.SPframestart.visible=false;
		targetRollOut.SPframeend.visible=false;
		targetRollOut.SampleTime.visible=false;
		targetRollOut.skinMeshList.visible=true;
		targetRollOut.boneNameList.visible=true;
	)else
	(
		targetRollOut.SPframestart.visible=true;
		targetRollOut.SPframeend.visible=true;
		targetRollOut.SampleTime.visible=true;
		targetRollOut.skinMeshList.visible=false;
		targetRollOut.boneNameList.visible=false;
	)
)
function setAnimateInfoUI obj targetRollOut num =
(
	
	names=getObjectSeting obj "objAnimate" "anims_names" true
	if(names==undefined or names.count==0) then
	(
		return false;
	)
	types=getObjectSeting obj "objAnimate" "anims_types" true
	targetRollOut.ListAnimations.text=names[num]
	targetRollOut.skeletonTypeList.selection=types[num];
	targetRollOut.skeletonTypeList.enabled=true;

	curSelectType=animateTypeArr[types[num]]
	
	if(curSelectType=="(挂载)动画") then
	(
		meshName=getObjectSeting obj "objAnimate" "anims_startframes" true
		boneName=getObjectSeting obj "objAnimate" "anims_endframes" true
		targetRollOut.skinMeshList.text = meshName[num]
		targetRollOut.boneNameList.text = boneName[num]
		
		targetRollOut.skinMeshList.enabled = true;
		targetRollOut.boneNameList.enabled = true;
	)else
	(
		startframes=getObjectSeting obj "objAnimate" "anims_startframes" true
		endframes=getObjectSeting obj "objAnimate" "anims_endframes" true
		lengths=getObjectSeting obj "objAnimate" "anims_lengths" true
		targetRollOut.SPframestart.value = startframes[num]
		targetRollOut.SPframeend.value = endframes[num]
		targetRollOut.SampleTime.value = lengths[num]
		targetRollOut.SPframestart.enabled = true;
		targetRollOut.SPframeend.enabled = true;

	)

	checkAnimateType obj targetRollOut curSelectType;

)
function setAndWriteAnimateType obj targetRollOut itemIndex num =
(
	types=getObjectSeting  obj "objAnimate" "anims_types" true;
	if(types==undefined or types.count==0) then
	(
		return false;
	)
	types[targetRollOut.ListAnimations.selection]=num;
	setObjectSeting obj "objAnimate" "anims_types" types;
	curSelectType=animateTypeArr[num];
	
	startframes=getObjectSeting obj "objAnimate" "anims_startframes" true
	endframes=getObjectSeting obj "objAnimate" "anims_endframes" true
	
	if(curSelectType=="(挂载)动画") then
	(
		startframes[itemIndex]="undefined"
		endframes[itemIndex]="undefined"
	)else
	(
		startframes[itemIndex]=1
		endframes[itemIndex]=2
	)
	setObjectSeting obj "objAnimate" "anims_startframes" startframes;
	setObjectSeting obj "objAnimate" "anims_endframes" endframes;
	setAnimateInfoUI obj targetRollOut itemIndex;
)
