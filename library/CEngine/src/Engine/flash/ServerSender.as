/**
 * @date	2011-3-3 上午11:05:43
 * @author  jianglang
 * 
 */	

package Engine.flash
{
	import flash.events.EventDispatcher;

	public class ServerSender extends EventDispatcher
	{
		private static var _instance:ServerSender;
		private static var  instanceNum:int=0;
		public function ServerSender()
		{
			instanceNum++;
			if( instanceNum>1 )
			{
				throw new Error("ServerSender 单例");
			}
		}
		public static function get instance():ServerSender
		{
			return _instance|| (_instance=new ServerSender());
		}
	}
}
