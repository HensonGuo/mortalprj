package frEngine.shader.registType
{
	import frEngine.shader.registType.base.RegistParam;

	public class VtParam extends RegistParam
	{
		public function VtParam($newName:String,$index:int)
		{
			super("vt"+$index,$index,$newName,false,null);
		}
	}
}


