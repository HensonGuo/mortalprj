package frEngine.loaders.ogreMaterialParse
{
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.loaders.base.Type_OgreMaterilaList_Base;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	import frEngine.shader.filters.fragmentFilters.TextureFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;

	public class Type_Material extends Type_OgreMaterilaList_Base
	{
		private var _folder:String;
		private var _batchInfo:BatchInfo;
		private var _technique:Type_Technique;
		private var _meshMaterialList:Dictionary=new Dictionary(false);
		public var folder:String;
		public var hasParse:Boolean=false;
		public var fragmentFilter:FragmentFilter;
		public function Type_Material(_name:String,folder:String)
		{
			super(_name);	 
			_folder=folder;
		}
		public function set batchInfo(value:BatchInfo):void
		{
			_batchInfo=value;
		}
		public function get batchInfo():BatchInfo
		{
			return _batchInfo;
		}
		public function get folderUrl():String
		{
			return _folder; 
		}
		public function get useBatch():Boolean
		{
			return _batchInfo && _batchInfo.useBatch;
		}
		public function setBothSides(mesh:Mesh3D,value:Boolean):void
		{
			if(useBatch)
			{
				return;
			}
			mesh.materialPrams.cullFace=value? Context3DTriangleFace.NONE : Context3DTriangleFace.BACK;
			
			
		}
		
		public function setTechniquePass(textureUrl:String):void
		{
			if(useBatch)
			{
				return;
			}
			var _technique:Type_Technique=new Type_Technique("defaultTechnique");
			var pass:Type_Pass=new Type_Pass("defaultPass");
			pass.texture_unit=new Type_Texture_unit("defaultTexture");
			pass.texture_unit.texture=Resource3dManager.instance.getTexture3d(textureUrl,1);
			_technique.pass=pass;
			technique=_technique;
		}
		public function set technique(value:Type_Technique):void
		{
			if(useBatch)
			{
				return;
			}
			_technique=value;
			var pass:Type_Pass=_technique.pass;
			var texture_unit:Type_Texture_unit=pass.texture_unit;
			
			if(texture_unit)
			{ 
				fragmentFilter=new TextureFilter(texture_unit.texture);
			}else if(pass.diffuse)
			{
				var color:Vector3D=pass.diffuse;
				fragmentFilter=new ColorFilter(color.x,color.y,color.z,color.w);
			}else
			{
				var r:Number=Math.random();
				var b:Number=Math.random();
				var g:Number=Math.random();
				fragmentFilter=new ColorFilter(r,b,g,1);
			}
			for each(var p:ShaderBase in _meshMaterialList)
			{
				p.setFragmentFilter(fragmentFilter);
			}
		}
		
		public function get technique():Type_Technique
		{
			return _technique;
		}
		public function getMaterial(mesh:Mesh3D):ShaderBase
		{
			//mesh.materialName=this.name;
			if(useBatch)
			{
				var typeMaterial:Type_BatchMaterial=batchInfo.targetBatchMaterial;  
				return typeMaterial.getMaterial(mesh);
			}
			var _material:ShaderBase=_meshMaterialList[mesh];
			if(_material==null)
			{
				fragmentFilter=new TextureFilter(Resource3dManager.instance.getTexture3d(Device3D.nullBitmapData,1));
				_meshMaterialList[mesh]=_material=new ShaderBase(this.name, new TransformFilter(0) ,fragmentFilter,mesh.materialPrams);
				//mesh.materialPrams.blendMode=Material3D.BLEND_ALPHA;
				//mesh.setLayer(Layer3DManager.AlphaLayer1);
			}
			return _material;
		}
	}
}