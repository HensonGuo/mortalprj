
function writeOgreMaterial material outFile =
(
	local t, matname, mat;

	mat = material ;
	
	if (mat != undefined) then 
	(
		matname = material.name ;	
		format "material %\n" matname to:outFile ;
		format "{\n" to:outFile ;
		format "\ttechnique\n" to:outFile ;
		format "\t{\n" to:outFile ;
		format "\t\tpass\n" to:outFile ;
		format "\t\t{\n" to:outFile ;
		format("\t\t\tambient % % %\n") (mat.ambient.r/255.0) (mat.ambient.g/255.0) (mat.ambient.b/255.0) to:outFile ;
	    format("\t\t\tdiffuse % % %\n") (mat.diffuse.r/255.0) (mat.diffuse.g/255.0) (mat.diffuse.b/255.0) to:outFile ;
    	format("\t\t\tspecular % % % %\n") (mat.specular.r/255.0) (mat.specular.g/255.0) (mat.specular.b/255.0) (mat.specularLevel*100.0) to:outFile ;
		format("\t\t\temissive % % %\n") (mat.selfIllumColor.r/255.0) (mat.selfIllumColor.g/255.0) (mat.selfIllumColor.b/255.0) to:outFile ;
		)
		if ((mat.diffusemap != undefined) and (iskindof mat.diffusemap Bitmaptexture)) then
		(	
			t = filterstring mat.diffusemap.filename "\\" ;
			format "\t\t\ttexture_unit\n" to:outFile ;
			format "\t\t\t{\n" to:outFile ;
			format "\t\t\t\ttexture % \n" t[arrayLength t] to:outFile ;
			format "\t\t\t}\n" to:outFile ;
		)
		format "\t\t}\n" to:outFile ;
		format "\t}\n" to:outFile ;
		format "}\n" to:outFile ;
)

function exportOgreMaterial material outName =
(
    local outFile ;
	if (classof material == OgreMaterial or classof material == ogreMaterial) then
	(
	    outFile = createfile outName ;
		writeOgreMaterial material outFile ;
		close outFile ;
		messageBox "Exporting material successful !" ;
	)
	else
	(
		messageBox "You have to choose an OgreMaterial." ;
	)
)

---------------------------------------------------------------
-- Writes a standard material in a material script
-- prefix will be before material name. (prefix+name)
-- used for multi material
---------------------------------------------------------------
function writeStandardMaterial material prefix outFile =
(
	local t ;
	matname = replaceSpaces material.name ;
	-- writes header	
	format "material %\n" (prefix+matname) to:outFile ;
	format "{\n" to:outFile ;
	format "\ttechnique\n" to:outFile ;
	format "\t{\n" to:outFile ;
	format "\t\tpass\n" to:outFile ;
	format "\t\t{\n" to:outFile ;

	format("\t\t\tambient % % %\n") (material.ambient.r/255.0) (material.ambient.g/255.0) (material.ambient.b/255.0) to:outFile ;
    format("\t\t\tdiffuse % % %\n") (material.diffuse.r/255.0) (material.diffuse.g/255.0) (material.diffuse.b/255.0) to:outFile ;
    format("\t\t\tspecular % % % %\n") (material.specular.r/255.0) (material.specular.g/255.0) (material.specular.b/255.0) (material.specularLevel*100.0) to:outFile ;
	format("\t\t\temissive % % %\n") (material.selfIllumColor.r/255.0) (material.selfIllumColor.g/255.0) (material.selfIllumColor.b/255.0) to:outFile ;
	-- tests if there is (or not) a diffuse map.
	if ((material.diffusemap != undefined) and (iskindof material.diffusemap Bitmaptexture)) then
	(	
		sourceUrl=material.diffusemap.filename
		t = filterstring sourceUrl "\\" ;
		bmpName=t[t.count]
		format "\t\t\ttexture_unit\n" to:outFile ;
		format "\t\t\t{\n" to:outFile ;
		format "\t\t\t\ttexture %\n" bmpName to:outFile ;
		format "\t\t\t}\n" to:outFile ;
		
		targetFoler=getInit "Settings" "sceneExportFolderUrl"
		if (not (doesFileExist sourceUrl)) then
		(
			sourceUrl = subString sourceUrl 4 -1;
			sourceUrl=maxFilePath+sourceUrl
		)
		copyFile sourceUrl (targetFoler+bmpName)
	)else
	(
		
	)
	format "\t\t}\n" to:outFile ;
	format "\t}\n" to:outFile ;
	format "}\n" to:outFile ;

)

---------------------------------------------------------------
-- Exports a standard material
-- PRE: material is a standard material
-- Use exportMaterial function.
---------------------------------------------------------------
function exportStandardMaterial material outFile =
(
	local sub,i,matname ;
	matname = replaceSpaces material.name ;
	writeStandardMaterial material "" outFile ;
)


---------------------------------------------------------------
-- Exports a multi material
-- PRE: material is a multi material
-- Use exportMaterial function.
---------------------------------------------------------------
function exportMultiMaterial material outFile=
(
	local sub,i,matname ;

	matname = replaceSpaces material.name ;
	
	i=0 ;
	for sub in material.materiallist do (
		i+=1 ;
		writeStandardMaterial sub (material.name+"/") outFile ;
		format "\n" to:outFile ;
	)
)



---------------------------------------------------------------
-- Exports a material
-- call the fonction linked to the material type
---------------------------------------------------------------
function exportMaterials materialList outName =
(
	
	local outFile ;
	if (not g_MAX) then
	(
		outFile = createfile outName ;
	)
	else
	(
		ClearListener();
		if (g_MAX_use_listener) then
			format("<ogrestartfile>%</ogrestartfile><ogrestartdata>\n") (outName);
		outFile = listener;
	)

	len=materialList.count;
	for i=1 to len do
	(
		mat=materialList[i];
		if (classof mat == MultiMaterial) then
		(
			exportMultiMaterial mat outFile ;
		)
		else if(classof mat == StandardMaterial) then
		(
			exportStandardMaterial mat outFile ;
		)
	)

	if (not g_MAX) then
	(
	    close outFile ;
	)
	else
	(
		if (g_MAX_use_listener) then
			format("</ogrestartdata>\n") to: outFile;
	)
	
	messageBox "Exporting material successful !" ;
)


---------------------------------------------------------------
-- Exports all the materials used in the scene
---------------------------------------------------------------
function exportAllSceneMaterials outname =
(
	local outFile ;
	if (not g_MAX) then
	(
		outFile = createfile outName ;
	)
	else
	(
		ClearListener();
		if (g_MAX_use_listener) then
			format("<ogrestartfile>%</ogrestartfile><ogrestartdata>\n") (outName);
		outFile = listener;
	)
	
	for material in sceneMaterials do
	(		
			
		if (material!=undefined and classof material == MultiMaterial) then
		(
			exportMultiMaterial material outFile ;
		)else 
		(
			if (material!=undefined and classof material == StandardMaterial) then
			(
				exportStandardMaterial material outFile ;
			)
				
		)
		format "\n" to:outFile ;
	)		

	if (not g_MAX) then
	(
	    close outFile ;
	)
	else
	(
		if (g_MAX_use_listener) then
			format("</ogrestartdata>\n") to: outFile;
	)

	--messageBox "Exporting all materials in the scene successful !" ;
)

