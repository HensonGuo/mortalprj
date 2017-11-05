package
{
	import flash.display.Sprite;
	import flash.net.SharedObject;
	import flash.system.Security;

	public class LocalObject extends Sprite
	{
		public function LocalObject()
		{
			Security.allowDomain("*");
		}
		public function getLocal(name:String, localPath:String = null, secure:Boolean = false):SharedObject
		{
			return SharedObject.getLocal(name,localPath,secure);
		}
	}
}