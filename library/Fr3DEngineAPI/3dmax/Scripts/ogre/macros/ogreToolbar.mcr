-- ogreToolbar.mcr
--
-- Banania - 2004
--
-- Macroscript for the Ogre Toolbar 2.0
--
-- Thanks to John Martin and Etienne Mallard for the work they did in the previous versions
--

-- library functions
include "ogre/scenceLib/Fr3dSceneLib_fns.ms"
include "ogre/scenceLib/Fr3dMaterialLib.ms"
include "ogre/lib/ogreSkeletonLib.ms"
include "ogre/lib/ogreMaterialPlugin.ms"
include "ogre/pcloudLib/OgrePcLibFuns.ms"
include "ogre/MD5Exporter/MD5AnimExporter.ms"
include "ogre/MD5Exporter/MD5MeshExporter.ms"
macroScript showOgreExportTools
	category:"Ogre Tools"
	internalCategory:"Ogre Tools"
	buttonText:"Ogre Exporter"
	tooltip:"Ogre Exporter"
	Icon:#("Maintoolbar",49)
(
	animateTypeArr=getInit "Settings" "animateType";
	md5MeshExp = MD5MeshExporter();
	md5AnimExp = MD5AnimExporter();
	-- create a floater
	rollout OgreExportOptions "Options" width:270 height:140 rolledUp:true
	(
		button openScript "open config.ini" pos:[7,8] width:116 height:26 toolTip:"open the script to edit your settings"
		checkbox CBconvertXML "convert XML file after export" pos:[8,42] width:255 height:22 checked:true
		label lbl01 "XML Converter Program" pos:[8,64] width:256 height:18
		editText editXMLconverter "" pos:[7,80] width:253 height:23
		button browseXMLconverter "Browse" pos:[188,106] width:72 height:25 toolTip:"choose your XML converter"
		groupBox grp1 "Conversion settings" pos:[8,132] width:254 height:125
		checkbox CBgenerateedges "Generate Edges List (for stencil shadows)" pos:[12,145] width:245 height:20 checked:true
		checkbox CBgeneratetangents "Generate Tangent Vectors (for normal mapping)" pos:[12,163] width:245 height:20 checked:false
		checkbox CBgenerateLOD "Generate LOD" pos:[12,181] width:245 height:20 checked:false
		label lbl02 "LOD levels" pos:[30,200] width:156 height:18
		label lbl03 "LOD distance" pos:[30,218] width:156 height:18
		label lbl04 "LOD reduction (%)" pos:[30,236] width:156 height:18
		spinner SPlodlevels "" pos:[120,200] width:114 height:16 range:[1,20,1] type:#integer scale:1 enabled:false
		spinner SPloddistance "" pos:[120,218] width:114 height:16 range:[0.0,100000.0,10.0] type:#float scale:1.0 enabled:false
		spinner SPlodreduction "" pos:[120,236] width:114 height:16 range:[0.0,100.0,20.0] type:#float scale:5.0 enabled:false

		on CBgenerateLOD changed state do
		(
			SPlodlevels.enabled = state;
			SPloddistance.enabled = state;
			SPlodreduction.enabled = state;
		)
		on openScript pressed  do
		(
			
			shellLaunch (getMaxFileUrl()) "";
		)
		on CBconvertXML changed state do
		(
			if (state and (editXMLconverter.text!="")) then
			(
				if (not (doesFileExist editXMLconverter.text)) then
				(
					editXMLconverter.text = "The file/directory specified in the .ini for the XML converter does not exist !";
					CBconvertXML.checked = false;
				)
			)
		)
		on browseXMLconverter pressed  do
		(
			filename = getOpenFileName types:"Executables(*.exe)|*.exe|" ;			
			if (filename != undefined) then
			(
				editXMLconverter.text = filename ;
				CBconvertXML.checked = true;
				if (not (doesFileExist editXMLconverter.text)) then
				(
					editXMLconverter.text = "The file/directory specified in the .ini for the XML converter does not exist !";
					CBconvertXML.checked = false;
				)
				else
				(
					xmlConvPath = getFilenamePath editXMLconverter.text;
					xmlexe = getFilenameFile editXMLconverter.text;
					setInit "Directories" "XMLConverterPath" xmlConvPath;
					setInit "Exe" "XMLConverterExe" xmlexe;
				)
			)
		)
		on OgreExportOptions open  do
		(
			curSelectObject=$;
			runXMLConverter = getInit "Tools" "runXMLConverter"
			if (runXMLConverter=="yes") then
			(
				CBconvertXML.enabled = true;
				CBconvertXML.checked = true;
			)
			else
			(
				CBconvertXML.enabled = false;
			)
			
			xmlConvPath = getInit "Directories" "XMLConverterPath"
			xmlexe = getInit "Exe" "XMLConverterExe"
			
			ext = substring xmlexe (xmlexe.count-4) 4;
			if ( (ext[2]!="e" and ext[2]!="E") or (ext[3]!="x" and ext[3]!="X") or (ext[4]!="e" and ext[4]!="E") ) then
				editXMLconverter.text = xmlConvPath + "\\" + xmlexe + ".exe";
			else
				editXMLconverter.text = xmlConvPath + "\\" + xmlexe;

			print editXMLconverter.text;
			if (not (doesFileExist editXMLconverter.text)) then
			(
				editXMLconverter.text = "The file/directory specified in the .ini for the XML converter does not exist !";
				CBconvertXML.checked = false;
			)
			else
			(
				CBconvertXML.checked = true;
			)
		)
		on OgreExportOptions close  do
		(
		
		)		
	)

	
	
	rollout OgreExportMesh "Mesh" width:270 height:120 rolledUp:true
	(
		groupBox grp2 "Export settings" pos:[4,25] width:262 height:102
		checkbox CBflipnormals "Flip normals" pos:[14,42] width:140 height:19
		checkbox CBexportUV "Export UV sets" pos:[14,64] width:140 height:20
		spinner SPchannels "# UV channels" pos:[36,85] width:173 height:16 range:[1,8,1] type:#integer scale:1
		checkbox CBexportColor "Export Vertex Color" pos:[13,105] width:140 height:19
		on OgreExportMesh open  do
		(
			curSelectObject=$;
			OgreExportMesh.CBflipnormals.enabled = false ;
			OgreExportMesh.CBexportColor.enabled = false ;
			OgreExportMesh.CBexportUV.enabled = false ;
			OgreExportMesh.CBexportUV.checked = true ;
			OgreExportMesh.SPchannels.enabled = false ;

			if ((curSelectObject!=undefined) and (iskindof curSelectObject GeometryClass)) then
			(
				OgreExportMesh.CBflipnormals.enabled = true ;
				OgreExportMesh.CBexportColor.enabled = true ;
				OgreExportMesh.CBexportUV.enabled = true ;
				if (classof curSelectObject == Editable_Mesh) then
				(
					if (getNumTVerts curSelectObject == 0) then
						OgreExportMesh.CBexportUV.checked = false ;
					else
						OgreExportMesh.CBexportUV.checked = true ;
				)
				else
				(
					OgreExportMesh.CBexportUV.checked = false ;
				)
				OgreExportMesh.SPchannels.enabled = true ;
			)
		)
		on OgreExportMesh close  do
		(
		
		)

		on CBexportUV changed state do
		(
			SPchannels.enabled = state ;
		)
		on SPchannels changed state do
		(
			--num_channels = (meshOp.getNumMaps curSelectObject) - 1;
			num_channels =1;
			if (state > num_channels) then
				SPchannels.value = num_channels;
		)
	)
	
	rollout OgreExportMaterial "Material" width:270 height:33 rolledUp:true
	(
		checkbox CBexportmaterial "Export Material" pos:[5,7] width:260 height:17 enabled:false
		on OgreExportMaterial open  do
		(
			curSelectObject=$;
			CBexportmaterial.enabled = false;

			if ((curSelectObject!=undefined) and (iskindof curSelectObject GeometryClass)) then
			(
				CBexportmaterial.enabled = true;
			)		
		)
		on OgreExportMaterial close  do
		(
			
		)
	)
	
	rollout OgreExportAnimation "导出动画设置" width:270 height:347 rolledUp:true
	(

		groupBox grp5 "Animations" pos:[8,10] width:253 height:240
		button addAnimation "Add" pos:[16,30] width:80 height:22 enabled:false toolTip:"add an animation to the list"
		button deleteAnimation "Delete" pos:[172,30] width:80 height:22 enabled:false toolTip:"remove an animation from the list"
		comboBox ListAnimations "" pos:[17,56] width:235 height:6 enabled:false
		
		dropdownlist skeletonTypeList "" pos:[17,155] width:236 height:16 enabled:false

		local start = animationRange.start.frame as Integer
		local end = animationRange.end.frame as Integer
		
		spinner SPframestart "from    " pos:[50,180] width:65 height:16 enabled:false range:[0,1000,start] type:#integer scale:1
		spinner SPframeend "to       " pos:[50,200] width:65 height:16 enabled:false range:[1,1000,end] type:#integer scale:1
		spinner SampleTime "skipTime" pos:[50,220] width:65 height:16 enabled:false range:[1,5,1] type:#integer scale:1

		editText skinMeshList "MeshName" pos:[32,180] width:180 height:16 enabled:false visible:false
		editText boneNameList "BoneName" pos:[32,200] width:180 height:16 enabled:false visible:false

		
		button reflashBtn "刷新" pos:[80,260] width:100 height:25
		
		on OgreExportAnimation open  do
		(
			curSelectObject=$;
			skeletonTypeList.items=animateTypeArr;
			--OgreExportAnimation.CBbiped.enabled = false;
			--OgreExportAnimation.CBbiped.checked = false;
		
			
			OgreExportAnimation.addAnimation.enabled = false;
			OgreExportAnimation.deleteAnimation.enabled = false;
			OgreExportAnimation.ListAnimations.enabled = false;
			OgreExportAnimation.SPframestart.enabled = false;
			OgreExportAnimation.SPframeend.enabled = false;
			OgreExportAnimation.SampleTime.enabled = false;
			OgreExportAnimation.skeletonTypeList.enabled=false;
			OgreExportAnimation.skinMeshList.visible=false;
			OgreExportAnimation.boneNameList.visible=false;
			
			OgreExportAnimation.SPframestart.visible=true;
			OgreExportAnimation.SPframeend.visible=true;
			OgreExportAnimation.SampleTime.visible = true;
			
			OgreExportAnimation.ListAnimations.text="";
			OgreExportAnimation.ListAnimations.selection=0;
			if ((curSelectObject!=undefined) and (iskindof curSelectObject GeometryClass)) then
			(
				OgreExportAnimation.addAnimation.enabled = true;
				OgreExportAnimation.deleteAnimation.enabled = true;
				OgreExportAnimation.ListAnimations.enabled = true;
				ListAnimations.items=getObjectSeting curSelectObject "objAnimate" "anims_names" true;
				checkAnimateType curSelectObject OgreExportAnimation curSelectType;
			)

		)

		on skinMeshList changed val do
		(
			num=ListAnimations.selection
			meshName=getObjectSeting curSelectObject "objAnimate" "anims_startframes" true
			meshName[num]=skinMeshList.text;
			setObjectSeting curSelectObject "objAnimate" "anims_startframes" meshName;
		)
		on boneNameList changed val do
		(
			num=ListAnimations.selection
			boneName=getObjectSeting curSelectObject "objAnimate" "anims_endframes" true
			boneName[num]=boneNameList.text;
			setObjectSeting curSelectObject "objAnimate" "anims_endframes" boneName;
		)
		
		on OgreExportAnimation close  do
		(
			
		)
		
		
		on reflashBtn pressed  do
		(
			curSelectObject=$;
			state=checkEnabled #() 
			OgreExportAnimation.addAnimation.enabled = state;
			OgreExportAnimation.deleteAnimation.enabled = state;
			OgreExportAnimation.ListAnimations.enabled = state;
			OgreExportAnimation.skeletonTypeList.enabled=false;
			OgreExportAnimation.skinMeshList.enabled=false;
			OgreExportAnimation.boneNameList.enabled=false;
			OgreExportAnimation.SPframestart.enabled = false;
			OgreExportAnimation.SPframeend.enabled = false;
			OgreExportAnimation.SampleTime.enabled = false;
			if(state==true) then
			(
				ListAnimations.items=getObjectSeting curSelectObject "objAnimate" "anims_names" true;
			)else
			(
				ListAnimations.items=#();
			)
			
		)
		on addAnimation pressed  do
		(
			if (ListAnimations.text != "") then
			(
				
				names=getObjectSeting curSelectObject "objAnimate" "anims_names" true
				startframes=getObjectSeting curSelectObject "objAnimate" "anims_startframes" true
				endframes=getObjectSeting curSelectObject "objAnimate" "anims_endframes" true
				lengths=getObjectSeting curSelectObject "objAnimate" "anims_lengths" true
				types=getObjectSeting curSelectObject "objAnimate" "anims_types" true
				append names ListAnimations.text;
				append startframes 1;
				append endframes 2;
				append lengths 1;
				append types 1;
				
				ListAnimations.items=names;
				ListAnimations.selection = 0;
				
				setObjectSeting curSelectObject "objAnimate" "anims_names" names
				setObjectSeting curSelectObject "objAnimate" "anims_startframes" startframes
				setObjectSeting curSelectObject "objAnimate" "anims_endframes" endframes
				setObjectSeting curSelectObject "objAnimate" "anims_lengths" lengths
				setObjectSeting curSelectObject "objAnimate" "anims_types" types
			)		
		)
		on deleteAnimation pressed  do
		(
			if ((ListAnimations.items.count > 0) and (ListAnimations.selection > 0)) then
			(
				names=getObjectSeting curSelectObject "objAnimate" "anims_names" true
				startframes=getObjectSeting curSelectObject "objAnimate" "anims_startframes" true
				endframes=getObjectSeting curSelectObject "objAnimate" "anims_endframes" true
				lengths=getObjectSeting curSelectObject "objAnimate" "anims_lengths" true
				types=getObjectSeting curSelectObject "objAnimate" "anims_types" true
				ind = ListAnimations.selection
				deleteItem names ind
				deleteItem startframes ind
				deleteItem endframes ind
				deleteItem lengths ind
				deleteItem types ind
				ListAnimations.items=names;
				ListAnimations.selection = 1;
				setObjectSeting curSelectObject "objAnimate" "anims_names" names
				setObjectSeting curSelectObject "objAnimate" "anims_startframes" startframes
				setObjectSeting curSelectObject "objAnimate" "anims_endframes" endframes
				setObjectSeting curSelectObject "objAnimate" "anims_lengths" lengths
				setObjectSeting curSelectObject "objAnimate" "anims_types" types
			)
		)
		on ListAnimations selected num  do
		(
			if (ListAnimations.items.count >= num) then
			(
				setAnimateInfoUI curSelectObject OgreExportAnimation num;
			)		
		)
		on skeletonTypeList selected num  do
		(
			if ((ListAnimations.items.count > 0) and (ListAnimations.selection > 0)) then
			(
				curSelectType=animateTypeArr[num]
				
				
				if(curSelectType=="(骨骼)动画") then
				(
					
					if( (isSkinMesh curSelectObject)==false ) then
					(
						num=types[ListAnimations.selection];
						skeletonTypeList.selection=num;
						messagebox (curSelectObject.name+",不合法的骨骼动画，设置失败");
						return false;
					)
				)
				
				setAndWriteAnimateType curSelectObject OgreExportAnimation ListAnimations.selection num;
			)		
		)
		on SPframestart changed val do
		(
			if ((ListAnimations.items.count > 0) and (ListAnimations.selection > 0)) then
			(
				names=getObjectSeting curSelectObject "objAnimate" "anims_names" true
				startframes=getObjectSeting curSelectObject "objAnimate" "anims_startframes" true
				if (ListAnimations.text == names[ListAnimations.selection]) then
				(
					startframes[ListAnimations.selection] = SPframestart.value;
					setObjectSeting curSelectObject "objAnimate" "anims_startframes" startframes
				)
					
			)		
		)
		on SPframeend changed val do
		(
			
			if ((ListAnimations.items.count > 0) and (ListAnimations.selection > 0)) then
			(
				names=getObjectSeting curSelectObject "objAnimate" "anims_names" true
				endframes=getObjectSeting curSelectObject "objAnimate" "anims_endframes" true
				if (ListAnimations.text == names[ListAnimations.selection]) then
				(
					endframes[ListAnimations.selection] = SPframeend.value;
					setObjectSeting curSelectObject "objAnimate" "anims_endframes" endframes
				)
					
			)		
		)
		on SampleTime changed val do
		(
			if ((ListAnimations.items.count > 0) and (ListAnimations.selection > 0)) then
			(
				names=getObjectSeting curSelectObject "objAnimate" "anims_names" true
				lengths=getObjectSeting curSelectObject "objAnimate" "anims_lengths" true
				if (ListAnimations.text == names[ListAnimations.selection]) then
				(
					lengths[ListAnimations.selection] = SampleTime.value;
					setObjectSeting curSelectObject "objAnimate" "anims_lengths" lengths
				)
					
			)		
		)
	)

	rollout OgreExportPcLoud "粒子" rolledUp:true
	(
		button exportBtn "export"  width:200 height:50 enabled:true toolTip:"export PcLoud List" align:#center;

		on exportBtn pressed  do
		(
			curSelectObject=$;
			
			sceneExportFolderUrl=getInit "Settings" "sceneExportFolderUrl"
			if (not (doesFileExist sceneExportFolderUrl)) then
			(
				messagebox "请先设置导出场景目录,或目录不存在！"
				return false;
			)
			
			
			if( ( curSelectObject == undefined ) or (classof curSelectObject != pcloud ) ) then
			(
				MessageBox "请选择要导出的PC粒子"
			)
			else
			(
				scesse=exportScene objects false false;
				explorePcLoad(curSelectObject)
			)
			
			
					
		)
	)
	
	rollout OgreObjectProperty "自定义物体属性" rolledUp:true
	(
		editText txt "" pos:[17,5] width:235 height:350 enabled:false
		button reflash "刷新" pos:[190,365] width:60 height:22 enabled:true toolTip:"刷新选种的物体"
		button saveBtn "保存" pos:[120,365] width:60 height:22 enabled:false
		button exportBtn "导出" pos:[50,365] width:60 height:22 enabled:false
		on OgreObjectProperty open  do
		(
			curSelectObject=$;
			enabledArr=#(txt,saveBtn,exportBtn);
			if(checkEnabled enabledArr) then
			(
				txt.text=getObjectSeting curSelectObject "objAnimate" "userData" false;
			)
		)
		on reflash pressed  do 
		(
			curSelectObject=$;
			if(checkEnabled enabledArr) then
			(
				txt.text=getObjectSeting curSelectObject "objAnimate" "userData" false;
			)
		)
		on saveBtn pressed  do 
		(
			if(checkEnabled enabledArr) then
			(
				setObjectSeting curSelectObject "objAnimate" "userData" txt.text;
			)
			
		)
		on exportBtn pressed  do 
		(
			sceneExportFolderUrl=getInit "Settings" "sceneExportFolderUrl"
			if (not (doesFileExist sceneExportFolderUrl)) then
			(
				messagebox "请先设置导出场景目录,或目录不存在！"
				return false;
			)
			
			if(checkEnabled enabledArr) then
			(
				setObjectSeting curSelectObject "objAnimate" "userData" txt.text;
			)
			checked=getInit "Settings" "exportNormal";
			exportScene objects (checked=="true") false
		)
			
			 
	)
	
	rollout OgreExportScene "场景"
	(
		groupBox grp1 "Output" pos:[8,7] width:254 height:75
		label lbl03 "FolderUrl" pos:[17,20] width:238 height:17
		editText editFilename "" pos:[11,35] width:242 height:22 scrollPos:[120,35] enabled:false
		button chooseFilename "Browse" pos:[170,60] width:82 height:20 toolTip:"chooose the name of your output files"
		
		checkbox exportNormal "exportNormal" pos:[17,90] width:100 height:19
		checkbox exportMesh "exportMesh" pos:[130,90] width:100 height:19 checked:true
		button exportBtn "export" pos:[30,115] width:200 height:50 enabled:true toolTip:"export PcLoud List"
		
		on OgreExportScene open  do
		(
			curSelectObject=$;
			editFilename.text=getInit "Settings" "sceneExportFolderUrl"
			checked=getInit "Settings" "exportNormal"
			if(checked=="true") then
			(
				exportNormal.checked=true;
			)else
			(
				exportNormal.checked=false;
			)
		)
		on exportNormal changed state do
		(
			setInit "Settings" "exportNormal" exportNormal.checked
		)
		on chooseFilename pressed  do
		(
			if(maxFilePath == "") then
			(
				messagebox "请先保存max文件！"
				return false;
			)
			fileFolder = getSavePath caption:"Select which directory \ holds the files:"
			--filename = getSaveFileName types:"All Files(*.*)|*.*|" ;			
			if (fileFolder != undefined) then
			(
				editFilename.text = fileFolder+"\\" ;
				setInit "Settings" "sceneExportFolderUrl" editFilename.text
			)
		)
		
		on exportBtn pressed  do
		(
			sceneExportFolderUrl=getInit "Settings" "sceneExportFolderUrl"
			if (not (doesFileExist sceneExportFolderUrl)) then
			(
				messagebox "请先设置导出场景目录,或目录不存在！"
				return false;
			)

			scesse=exportScene objects exportNormal.checked exportMesh.checked;
			if(scesse==true) then
			(
				local outName=sceneExportFolderUrl+(replaceStr maxFileName ".max" ".material")
				exportAllSceneMaterials outName
				messagebox "成功导出场景！"
			)else
			(
				messagebox "导出场景失败！"
			)
		)
		
	)
	
	
	if OgreExportFloater != undefined then
	(
		closeRolloutFloater OgreExportFloater
		
	)
	
	OgreExportFloater = newRolloutFloater "Ogre Exporter - 1.19" 280 600 ;
	
	-- add the rollout, which contains the dialog	
	addRollout OgreExportOptions OgreExportFloater ;
	addRollout OgreExportMesh OgreExportFloater ;
	addRollout OgreExportMaterial OgreExportFloater ;
	addRollout OgreExportAnimation OgreExportFloater ;
	addRollout OgreExportPcLoud OgreExportFloater ;
	addRollout OgreObjectProperty OgreExportFloater ;
	addRollout OgreExportScene OgreExportFloater ;
	
	
	
)
