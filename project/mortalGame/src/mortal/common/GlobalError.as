package mortal.common
{
	import com.gengine.core.Singleton;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.IEventDispatcher;
	
	import mortal.common.global.ParamsConst;
	import mortal.component.window.DebugWindow;
	
	public class GlobalError extends Singleton
	{
		private static var _instance:GlobalError;
		
		
		public function GlobalError(  )
		{
			
		}
		
		public static function get instance():GlobalError
		{
			if( _instance == null )
			{
				_instance = new GlobalError();
			}
			return _instance;
		}
		
		public function listenerError():void
		{
			watch(Global.stage.loaderInfo);
			if(Global.stage.loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				for(var i : int = 0;i < Global.stage.numChildren;i++) 
				{
					watch(Global.stage.getChildAt(i).loaderInfo);
				}
			}
		}
		
		//		private function uncaughtErrorHandler(event:UncaughtErrorEven):void
		//		{
		//			var message:String;
		//			
		//			if (event.error is Error)
		//			{
		//				message = Error(event.error).message;
		//			}
		//			else if (event.error is ErrorEvent)
		//			{
		//				message = ErrorEvent(event.error).text;
		//			}
		//			else
		//			{
		//				message = event.error.toString();
		//			}
		//			
		//			Log.debug(message);
		//			DebugWindow.instance.show()
		//		}
		
		private var lastErrorMsg:String;
		
		private function uncaughtErrorHandler(event : ErrorEvent) : void 
		{
			event.preventDefault();
//			event.stopImmediatePropagation();
			
			var message:String;
			var error : * = event['error'];
			if(error.hasOwnProperty("getStackTrace"))
			{
				message = error.getStackTrace();
			}
			else if (error is Error)
			{
				message = Error(error).message;
			}
			else if (error is ErrorEvent)
			{
				message = ErrorEvent(error).text;
			}
			else
			{
				message = error.toString();
			}
			if(lastErrorMsg == message)
			{
				return;
			}
			lastErrorMsg = message;
			Log.error(message);
			if(Global.isDebugModle || ParamsConst.instance.isShowError)
			{
				DebugWindow.instance.show();
			}
		}
		
		public function watch(loaderInfo : LoaderInfo) : void 
		{
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
			}
		}
		
		public function unwatch(loaderInfo : LoaderInfo) : void 
		{
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) 
			{
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).removeEventListener("uncaughtError", uncaughtErrorHandler);
			}
		}
	}
}