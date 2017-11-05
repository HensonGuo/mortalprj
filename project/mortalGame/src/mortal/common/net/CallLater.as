/**
 * @date	2011-3-2 上午10:58:19
 * @author  jianglang
 * 
 */	

package mortal.common.net
{
	import com.gengine.core.call.Caller;
	import com.gengine.utils.HashMap;
	
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CallLater
	{
		private static var _call:Caller = new Caller();
		
		private static var _isCall:Boolean = false;
		
		private static var CallType:String = "CallLater";
		
		private static var _closureMap:Dictionary = new Dictionary();
		
		public function CallLater()
		{
			
		}
		
//		private static var callLaterHashMap:HashMap = new HashMap();
//		private static var time:int = 0;
		
		/**
		 * time 目前支持秒为单位的 
		 * @param fun
		 * @param time
		 * @param rest
		 * 
		 */		
		public static function setCallLater(fun:Function,time:int,...rest):int
		{
			return setTimeout(fun,time * 1000,rest);
		}
		
		/**
		 * 移除callLater 
		 * @param time
		 * 
		 */		
		public static function removeCallLater(time:int):void
		{
			clearTimeout( time );
		}
		
		public static function addCallBack( closure:Function):void
		{
			if( closure in _closureMap ) return;
			_call.addCall(CallType,closure);
			if( _isCall == false)
			{
				setTimeout(callBack,50);
				_isCall = true;
			}
		}
		
		private static function callBack():void
		{
			_call.call(CallType);
			_isCall = false;
			_call.removeCallByType(CallType);
			_closureMap = new Dictionary();
		}
	}
}