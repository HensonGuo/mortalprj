package frEngine.shader.registType
{
	import frEngine.shader.registType.base.RegistParam;

	public class FtParam extends RegistParam
	{
		
		public function FtParam($newName:String,$index:int)
		{
			super("ft"+$index,$index,$newName,false,null);
		}
	}
}