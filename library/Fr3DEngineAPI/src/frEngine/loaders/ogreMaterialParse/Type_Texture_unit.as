package frEngine.loaders.ogreMaterialParse
{
	import baseEngine.core.Texture3D;
	
	import frEngine.loaders.base.Type_OgreMaterilaList_Base;

	public class Type_Texture_unit extends Type_OgreMaterilaList_Base
	{
		public var texture:Texture3D;
		public var linear:Boolean=true;
		public var miplinear:Boolean=true;
		public var repeat:Boolean=true;
		public function Type_Texture_unit(_name:String)
		{
			super(_name);	
		}
	}
}