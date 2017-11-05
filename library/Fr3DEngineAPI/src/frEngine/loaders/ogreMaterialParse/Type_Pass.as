package frEngine.loaders.ogreMaterialParse
{
	import flash.geom.Vector3D;
	
	import frEngine.loaders.base.Type_OgreMaterilaList_Base;

	public class Type_Pass extends Type_OgreMaterilaList_Base
	{
		public var ambient:Vector3D;
		public var diffuse:Vector3D;
		public var specular:Vector3D;
		public var texture_unit:Type_Texture_unit;
		public function Type_Pass(_name:String)
		{
			super(_name);	
		}
	}
}