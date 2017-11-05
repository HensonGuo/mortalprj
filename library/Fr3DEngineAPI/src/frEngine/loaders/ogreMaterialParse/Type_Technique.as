package frEngine.loaders.ogreMaterialParse
{
	import frEngine.loaders.base.Type_OgreMaterilaList_Base;

	public class Type_Technique extends Type_OgreMaterilaList_Base
	{
		public var pass:Type_Pass;
		public function Type_Technique(_name:String)
		{
			super(_name);	
		}
	}
}