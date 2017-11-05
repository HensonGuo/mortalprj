package frEngine.loaders
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	
	import frEngine.loaders.ogreMaterialParse.OgreMaterialSerializer;
	import frEngine.loaders.ogreMaterialParse.Type_BatchMaterial;
	import frEngine.loaders.ogreMaterialParse.Type_Material;
	import frEngine.shader.ShaderBase;

	public class OgreMaterialListManager extends EventDispatcher
	{
		public static const instance:OgreMaterialListManager=new OgreMaterialListManager();
		private var defaultMap:OgreMaterialSerializer=new OgreMaterialSerializer();
		private var otherMap:Dictionary=new Dictionary(false);
		private var listenners:Dictionary=new Dictionary(false);
		private const defaultFlag:String="default";
		
		public function OgreMaterialListManager()
		{
			super(null);
		}
		public function addDefaultFileFolder(fileName:String):void
		{
			getMaterialParser(null).addMaterialFile(fileName);
		}
		public function addFileFolder(fileFolderUrl:String,fileName:String):void
		{
			getMaterialParser(fileFolderUrl).addMaterialFile(fileFolderUrl+fileName);
		}

		private function getMaterialParser(folderUrl:String):OgreMaterialSerializer
		{
			if(folderUrl==null)
			{
				return defaultMap
			}else
			{
				if(!otherMap[folderUrl])
				{
					otherMap[folderUrl]=new OgreMaterialSerializer();
				}
				return otherMap[folderUrl]
			}
		}
		public function getMaterial(mesh:Mesh3D,materialName:String, foldurl:String=null):ShaderBase
		{
			return getMaterialParser(foldurl).getMaterial(mesh,materialName);
		}

		public function getTypeMaterial(materialName:String, foldurl:String=null):Type_Material
		{
			return getMaterialParser(foldurl).get_Type_material(materialName);
		}
		public function getTypeBatchMaterial(materialName:String, foldurl:String=null):Type_BatchMaterial
		{
			return getMaterialParser(foldurl).get_Type_BatchMaterial(materialName);
		}
	}
}