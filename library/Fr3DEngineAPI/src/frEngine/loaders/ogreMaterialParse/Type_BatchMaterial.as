package frEngine.loaders.ogreMaterialParse
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	
	import frEngine.shader.BatchFrPlaneShader;
	import frEngine.shader.ShaderBase;

	public class Type_BatchMaterial extends Type_Material
	{
		private var allSameMaterial:ShaderBase;
		private var uvInfoByName:Dictionary=new Dictionary(false);
		private var typeList:Dictionary=new Dictionary(false);
		private var planeBatchMaterial:BatchFrPlaneShader=new BatchFrPlaneShader("",null,uvInfoByName,null);
		public function Type_BatchMaterial(_name:String,folder:String)
		{
			super(_name,folder);
		}
		public override function getMaterial(mesh:Mesh3D):ShaderBase
		{
			return allSameMaterial;
		}
		public function registSubMaterial(subMaterialName:String,w:int,h:int,centerX:int,centerY:int):void
		{
			var imgw:int=batchInfo.imgW;
			var imgh:int=batchInfo.imgH;
			uvInfoByName[subMaterialName]=new Vector3D(	w/imgw,	h/imgh,	(centerX-w/2)/imgw,	(centerY-h/2)/imgh	);
		}
		
		public override function set batchInfo(value:BatchInfo):void
		{
			super.batchInfo=value; 
			var targetShader:ShaderBase
			switch(value.batchType)
			{
				case "plane":		targetShader=planeBatchMaterial; 
									targetShader.setFragmentFilter(this.fragmentFilter);
									break;
			}
			
			allSameMaterial=targetShader;
		}
		public override function set technique(value:Type_Technique):void
		{
			super.technique=value;
			allSameMaterial.setFragmentFilter(fragmentFilter);
			
		}
	}
}