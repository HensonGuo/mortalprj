package mortal.common
{
	import com.gengine.core.call.Caller;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class LaterUtil
	{
		private static var _caller:Caller;
		private static var dicCallLaer:Dictionary = new Dictionary();
		
		public static const Pack:String = "ReleasePack";
		public static const Arena:String = "ReleaseArena";
		public static const GangFights:String = "ReleaseGangFights";
		public static const CopyRelease:String = "CopyRelease";
		public static const PetBtnOver:String = "PetBtnOver";
		
		/**
		 * 延迟回调。 可以用于处理资源释放
		 * 
		 */		
		public function LaterUtil()
		{
		}
		
		/**
		 * 开始计时   (比如离开副本调用)
		 * @param type
		 * @param delayTime 延迟时间 秒数
		 */
		public static function addCallLater(type:Object,callBack:Function,delayTime:Number = 120):void
		{
			if(!caller.hasCallFun(type,callBack))
			{
				caller.addCall(type,callBack);
			}
			//停止计时
			stopCallLater(type);
			//重新计时
			dicCallLaer[type] = setTimeout(call,delayTime * 1000,type);
		}
		
		/**
		 * 停止计时  (比如进入副本调用)
		 * @param type
		 * 
		 */
		public static function stopCallLater(type:Object):void
		{
			if(dicCallLaer.hasOwnProperty(type))
			{
				var uid:uint = dicCallLaer[type] as uint;
				clearTimeout(uid);
			}
		}
		
		/**
		 * 回调 
		 * 
		 */	
		private static function call(type:Object):void
		{
			caller.call(type);
			caller.removeCallByType(type);
		}
		
		private static function get caller():Caller
		{
			if(!_caller)
			{
				_caller = new Caller();
			}
			return _caller;
		}
	}
}