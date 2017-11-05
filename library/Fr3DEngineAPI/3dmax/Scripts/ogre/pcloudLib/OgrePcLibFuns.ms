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
	messagebox "�������ӳɹ���"
	
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
	
	format("\t<paticle_general><!--��������-->\n")  to:outFile ;
	format("\t\t<formation value='%'/><!--���䷽ʽ-->\n") targetPcLoud.formation to:outFile ;
	if (targetPcLoud.formation==3 and targetPcLoud.emitter!=undefined) then
	(
		tempfileName=replaceSpaces targetPcLoud.emitter.name;
		--exportNode targetPcLoud.emitter (fileFolder+"\\"+tempfileName) false
		format("\t\t<emitter value='%'/>\n") tempfileName to:outFile ;
	)
	format("\t\t<emitter_rad_len value='%'/><!--�����峤��-->\n") targetPcLoud.emitter_rad_len to:outFile ;
	format("\t\t<emitter_width value='%'/><!--�������-->\n") targetPcLoud.emitter_width to:outFile ;
	format("\t\t<emitter_height value='%'/><!--�������-->\n") targetPcLoud.emitter_height to:outFile ;
	format("\t\t<quantityMethod value='%'/><!--���䷽ʽ-->\n") targetPcLoud.quantityMethod to:outFile ;
	format("\t\t<birth_rate value='%'/><!--��������-->\n") targetPcLoud.birth_rate to:outFile ;
	format("\t\t<total_number value='%'/><!--��������-->\n") targetPcLoud.total_number to:outFile ;
	format("\t\t<speed value='%'/><!--�����ٶ�-->\n") targetPcLoud.speed to:outFile ;
	format("\t\t<speed_variation value='%'/><!--�����ʼ�ٶȱ仯��-->\n") targetPcLoud.speed_variation to:outFile ;
	format("\t\t<motionType value='%'/><!--�˶���ʽ-->\n") targetPcLoud.motionType to:outFile ;
	format("\t\t<direction_vector_x value='%'/><!--�˶�����x-->\n") targetPcLoud.direction_vector_x to:outFile ;
	format("\t\t<direction_vector_y value='%'/><!--�˶�����y-->\n") targetPcLoud.direction_vector_z to:outFile ;
	format("\t\t<direction_vector_z value='%'/><!--�˶�����z-->\n") targetPcLoud.direction_vector_y to:outFile ;
	if(targetPcLoud.motionType==2) then
	(
		format("\t\t<motionReferenceObject value='%'/><!--���ӷ���ʵ����������ʹ��-->\n") targetPcLoud.motionReferenceObject to:outFile ;
	)
	format("\t\t<directionVariation value='%'/><!--���ӷ��䷽��仯��-->\n") targetPcLoud.directionVariation to:outFile ;
	format("\t\t<speed_direction_variation value='%'/><!--���ӷ��䷽��仯��-->\n") targetPcLoud.speed_direction_variation to:outFile ;
	format("\t\t<emitter_start value='%'/><!--���ӿ�ʼʱ��֡��-->\n") targetPcLoud.emitter_start to:outFile ;
	format("\t\t<emitter_stop value='%'/><!--���ӽ���ʱ��֡��-->\n") targetPcLoud.emitter_stop to:outFile ;
	format("\t\t<display_until value='%'/><!--����ȫ������֡��-->\n") targetPcLoud.display_until to:outFile ;
	format("\t\t<life value='%'/><!--������������-->\n") targetPcLoud.life to:outFile ;
	format("\t\t<life_variation value='%'/><!--���������仯��-->\n") targetPcLoud.life_variation to:outFile ;
	format("\t\t<size value='%'/><!--���Ӵ�С-->\n") targetPcLoud.size to:outFile ;
	format("\t\t<size_variation value='%'/><!--���Ӵ�С�仯��-->\n") targetPcLoud.size_variation to:outFile ;
	format("\t\t<growth_time value='%'/><!--���Ӵ���С��Ŀ���Сʱ��֡��-->\n") targetPcLoud.growth_time to:outFile ;
	format("\t\t<fade_time value='%'/><!--���Ӵ�Ŀ���С����С�ߴ�ʱ��֡��-->\n") targetPcLoud.fade_time to:outFile ;
	format("\t\t<seed value='%'/><!--�����������С-->\n") targetPcLoud.seed to:outFile ;
	--format("\t\t<random_seed value='%'/><!--�����������С-->\n") targetPcLoud.random_seed to:outFile ;
	format("\t</paticle_general>\n")  to:outFile ;

	format("\t<paticle_type><!--��������-->\n")  to:outFile ;
	format("\t\t<particleType value='%'/><!--��������-->\n") targetPcLoud.particleType to:outFile ;
	format("\t\t<standardparticle value='%'/><!--��׼�������-->\n") targetPcLoud.standardparticle to:outFile ;
	format("\t\t<metaparticle_tension value='%'/><!--������������-->\n") targetPcLoud.metaparticle_tension to:outFile ;
	format("\t\t<metaparticle_tension_variation value='%'/><!--�������������仯��-->\n") targetPcLoud.metaparticle_tension_variation to:outFile ;
	if(targetPcLoud.particleType==2 and targetPcLoud.instancingObject!=undefined ) then
	(
		tempfileName=replaceSpaces targetPcLoud.instancingObject.name;
		format("\t\t<instancingObject value='%'/><!--ʵ������-->\n") tempfileName to:outFile ;
		--exportNode targetPcLoud.instancingObject (fileFolder+"\\"+tempfileName) true
	)
	format("\t</paticle_type>\n")  to:outFile ;
	
	format("\t<paticle_motion_inheritance><!--�����˶��̳�-->\n")  to:outFile ;
	format("\t\t<motionMultiplier value='%'/><!--������-->\n") targetPcLoud.motionMultiplier to:outFile ;
	format("\t</paticle_motion_inheritance>\n")  to:outFile ;

	format("</pcloud>") to:outFile 
	close outFile;
	return true;
)


