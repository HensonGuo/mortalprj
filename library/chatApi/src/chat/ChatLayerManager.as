package chat
{
	import com.gengine.global.Global;
	
	import flash.display.Sprite;

	public class ChatLayerManager
	{
		public static var uiLayer:Sprite;
		public static var menuLayer:Sprite;
		public static var windowLayer:Sprite;
		public function ChatLayerManager()
		{
		}
		
		public static function init():void
		{
			uiLayer = new Sprite();
			uiLayer.tabChildren = false;
			uiLayer.mouseEnabled = false;
			Global.application.addChild(uiLayer);
			
			menuLayer = new Sprite();
			menuLayer.tabChildren = false;
			Global.application.addChild(menuLayer);
			
			windowLayer = new Sprite();
			windowLayer.tabChildren = false;
			Global.application.addChild(windowLayer);
			
		}
	}
}