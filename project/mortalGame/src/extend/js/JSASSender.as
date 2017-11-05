package extend.js
{
	import com.gengine.core.frame.FrameManager;
	import com.gengine.global.Global;
	import com.gengine.manager.CacheManager;
	
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	public class JSASSender
	{
		private static var _instance:JSASSender;
		public function JSASSender()
		{
			if( _instance != null )
			{
				throw new Error("JSASSender单例");
			}
			Security.allowDomain("*");
		}
		/**
		 * 关闭浏览器 
		 * 
		 */		
		private function jsClose():void
		{
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.FlashClose);
			}
		}
		
		private function cacheClear():void
		{
			CacheManager.instance.clear();
		}
		
		private function init():void
		{
			if( ExternalInterface.available )
			{
				ExternalInterface.marshallExceptions = true;
				try
				{
					ExternalInterface.addCallback("cacheClear",cacheClear);
					ExternalInterface.addCallback("jsClose",jsClose);
				}
				catch(e:*){}
			}
		}
		
		public function start():void
		{
			Global.stage.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler( event:Event ):void
		{
			if( !ExternalInterface.available )
				return;
			Global.stage.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			init();
//			callJsSetInterval();
		}
		/**
		 * 调用JS 计时器 
		 * 
		 */		
		private function callJsSetInterval():void
		{
			if( !ExternalInterface.available )
				return;
			ExternalInterface.call("asCallJs");
		}
		
		private var type:int = 0;
		/**
		 * 缩放地图 
		 * 
		 */		
		public function callMapResize( $type:int ):void
		{
			if( !ExternalInterface.available )
				return;
			if( this.type == 1 )
			{
				this.type = 0;
			}
			else
			{
				this.type = 1;
			}
			ExternalInterface.call("callMapResize",type);
		}
		
		public static function get instance():JSASSender
		{
			if( _instance == null)
			{
				_instance = new JSASSender();
			}
			
			return _instance;
		}
		
		public function jsCall():void
		{
			FrameManager.flashFrame.dispatchEvent();
		}
	}
}