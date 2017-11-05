package frEngine.shader.registType
{
	import frEngine.shader.registType.base.RegistParam;

	public class Vparam extends RegistParam
	{
		
		public function Vparam($newName:String,$index:int)
		{
			super("v"+$index,$index,$newName,false,null);
		}
	}
}



