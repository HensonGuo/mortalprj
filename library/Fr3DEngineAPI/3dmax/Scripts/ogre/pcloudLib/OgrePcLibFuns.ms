include "ogre/lib/ogreSkeletonLib_usefulfns.ms"
include "ogre/lib/OgreSkeletonLib_meshfns.ms"

-----------------------------------------------------------------
function exportNode nodeObj filename exportUV =
(
	clearlistener() ;
	Options = exportOptions scale:1.0 flipYZ:true flipNormal:true exportColours:false exportUV:false UVchannels:1;
	Options.exportUV=exportUV;
	exportingMeshDone = false ;
	exportingSkelDone = false ;
	-- sets options
	Options.exportHelpers = false;
	-- exports mesh
	---------------
	-- m = getNodeByName editObject.text ;
	exportingMeshDone = writeMesh nodeObj Options filename ;
	--progressStop ;
)

function explorePcLoad targetPcLoud =
(
	local exportFolder=getInit "Settings" "sceneExportFolderUrl"
	local meshName=getObjectMeshFileUrl targetPcLoud ".mesh"
	filename=exportFolder+meshName;
	impExportPcload targetPcLoud filename
	messagebox "导出粒子成功！"
	
)
function impExportPcload targetPcLoud fileUrl =
(
	if (g_MAX) then
	(
		ClearListener();
		outFile = listener;
	)
	else
	(
		outFile = createfile fileUrl ;
	)

	format("<pcloud>\n") true to:outFile ;

	format("\t<paticle_node>\n")  to:outFile ;
	format("\t\t<pos x='%' y='%' z='%'/>\n") targetPcLoud.pos.x targetPcLoud.pos.y targetPcLoud.pos.z to:outFile ;
	format("\t\t<scale x='%' y='%' z='%'/>\n") targetPcLoud.scale.x targetPcLoud.scale.y targetPcLoud.scale.z to:outFile ;
	format("\t\t<rotation x='%' y='%' z='%'/>\n") targetPcLoud.rotation.x targetPcLoud.rotation.y targetPcLoud.rotation.z to:outFile ;
	if( targetPcLoud.material!=undefined ) then
	(
		materialName= replaceSpaces targetPcLoud.material.name
		format("\t\t<material value='%'/>\n") materialName to:outFile ;
	)
	local start = animationRange.start
	local end = animationRange.end
	format("\t\t<timeLen value='%'/>\n") (end-start) to:outFile ;
	format("\t</paticle_node>\n")  to:outFile ;
	
	format("\t<paticle_general><!--粒子生成-->\n")  to:outFile ;
	format("\t\t<formation value='%'/><!--发射方式-->\n") targetPcLoud.formation to:outFile ;
	if (targetPcLoud.formation==3 and targetPcLoud.emitter!=undefined) then
	(
		tempfileName=replaceSpaces targetPcLoud.emitter.name;
		--exportNode targetPcLoud.emitter (fileFolder+"\\"+tempfileName) false
		format("\t\t<emitter value='%'/>\n") tempfileName to:outFile ;
	)
	format("\t\t<emitter_rad_len value='%'/><!--发射体长度-->\n") targetPcLoud.emitter_rad_len to:outFile ;
	format("\t\t<emitter_width value='%'/><!--发射体宽-->\n") targetPcLoud.emitter_width to:outFile ;
	format("\t\t<emitter_height value='%'/><!--发射体高-->\n") targetPcLoud.emitter_height to:outFile ;
	format("\t\t<quantityMethod value='%'/><!--发射方式-->\n") targetPcLoud.quantityMethod to:outFile ;
	format("\t\t<birth_rate value='%'/><!--发射速率-->\n") targetPcLoud.birth_rate to:outFile ;
	format("\t\t<total_number value='%'/><!--发射总数-->\n") targetPcLoud.total_number to:outFile ;
	format("\t\t<speed value='%'/><!--发射速度-->\n") targetPcLoud.speed to:outFile ;
	format("\t\t<speed_variation value='%'/><!--发射初始速度变化量-->\n") targetPcLoud.speed_variation to:outFile ;
	format("\t\t<motionType value='%'/><!--运动方式-->\n") targetPcLoud.motionType to:outFile ;
	format("\t\t<direction_vector_x value='%'/><!--运动方向x-->\n") targetPcLoud.direction_vector_x to:outFile ;
	format("\t\t<direction_vector_y value='%'/><!--运动方向y-->\n") targetPcLoud.direction_vector_z to:outFile ;
	format("\t\t<direction_vector_z value='%'/><!--运动方向z-->\n") targetPcLoud.direction_vector_y to:outFile ;
	if(targetPcLoud.motionType==2) then
	(
		format("\t\t<motionReferenceObject value='%'/><!--粒子发射实例对像，暂无使用-->\n") targetPcLoud.motionReferenceObject to:outFile ;
	)
	format("\t\t<directionVariation value='%'/><!--粒子发射方向变化量-->\n") targetPcLoud.directionVariation to:outFile ;
	format("\t\t<speed_direction_variation value='%'/><!--粒子发射方向变化量-->\n") targetPcLoud.speed_direction_variation to:outFile ;
	format("\t\t<emitter_start value='%'/><!--粒子开始时间帧数-->\n") targetPcLoud.emitter_start to:outFile ;
	format("\t\t<emitter_stop value='%'/><!--粒子结束时间帧数-->\n") targetPcLoud.emitter_stop to:outFile ;
	format("\t\t<display_until value='%'/><!--粒子全部消亡帧数-->\n") targetPcLoud.display_until to:outFile ;
	format("\t\t<life value='%'/><!--粒子生命周期-->\n") targetPcLoud.life to:outFile ;
	format("\t\t<life_variation value='%'/><!--粒子生命变化量-->\n") targetPcLoud.life_variation to:outFile ;
	format("\t\t<size value='%'/><!--粒子大小-->\n") targetPcLoud.size to:outFile ;
	format("\t\t<size_variation value='%'/><!--粒子大小变化量-->\n") targetPcLoud.size_variation to:outFile ;
	format("\t\t<growth_time value='%'/><!--粒子从最小到目标大小时间帧数-->\n") targetPcLoud.growth_time to:outFile ;
	format("\t\t<fade_time value='%'/><!--粒子从目标大小到最小尺寸时间帧数-->\n") targetPcLoud.fade_time to:outFile ;
	format("\t\t<seed value='%'/><!--粒子随机数大小-->\n") targetPcLoud.seed to:outFile ;
	--format("\t\t<random_seed value='%'/><!--粒子随机数大小-->\n") targetPcLoud.random_seed to:outFile ;
	format("\t</paticle_general>\n")  to:outFile ;

	format("\t<paticle_type><!--粒子类型-->\n")  to:outFile ;
	format("\t\t<particleType value='%'/><!--粒子类型-->\n") targetPcLoud.particleType to:outFile ;
	format("\t\t<standardparticle value='%'/><!--标准粒子类别-->\n") targetPcLoud.standardparticle to:outFile ;
	format("\t\t<metaparticle_tension value='%'/><!--球形粒子张力-->\n") targetPcLoud.metaparticle_tension to:outFile ;
	format("\t\t<metaparticle_tension_variation value='%'/><!--球形粒子张力变化量-->\n") targetPcLoud.metaparticle_tension_variation to:outFile ;
	if(targetPcLoud.particleType==2 and targetPcLoud.instancingObject!=undefined ) then
	(
		tempfileName=replaceSpaces targetPcLoud.instancingObject.name;
		format("\t\t<instancingObject value='%'/><!--实例对像-->\n") tempfileName to:outFile ;
		--exportNode targetPcLoud.instancingObject (fileFolder+"\\"+tempfileName) true
	)
	format("\t</paticle_type>\n")  to:outFile ;
	
	format("\t<paticle_motion_inheritance><!--粒子运动继承-->\n")  to:outFile ;
	format("\t\t<motionMultiplier value='%'/><!--倍增量-->\n") targetPcLoud.motionMultiplier to:outFile ;
	format("\t</paticle_motion_inheritance>\n")  to:outFile ;

	format("</pcloud>") to:outFile 
	close outFile;
	return true;
)



