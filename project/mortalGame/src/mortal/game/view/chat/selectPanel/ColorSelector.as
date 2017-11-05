package mortal.game.view.chat.selectPanel
{
	import com.gengine.global.Global;
	import com.mui.controls.GSprite;
	import com.mui.core.IFrUI;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	
	public class ColorSelector extends GSprite
	{
		private var colorArr:Array = new Array(0xFFBee8fe,0xFF00FCFF,0xFFffc293,0xFFffe200,0xFFff00e4,0xFFFF0000);
		public function ColorSelector()
		{
			super();
		}
		
		private static var _instance:ColorSelector;
		private static var _currentBtn:InteractiveObject;
		private static var _dicbtnCallback:Dictionary = new Dictionary();
		
		public static function get instance():ColorSelector
		{
			if(!_instance)
			{
				_instance = new ColorSelector();
			}
			return _instance;
		}
		
		/**
		 * 注册一个按钮 
		 * @param btn
		 * 
		 */
		public static function registBtn(btn:IFrUI,callBack:Function):void
		{
			_dicbtnCallback[btn] = callBack;
			btn.configEventListener(MouseEvent.CLICK,onClickBtn);
		}
		
		/**
		 * 取消注册按钮 
		 * @param btn
		 * 
		 */
		public static function unRegistBtn(btn:IFrUI):void
		{
			if(btn)
			{
				(btn as InteractiveObject).removeEventListener(MouseEvent.CLICK,onClickBtn);
				delete _dicbtnCallback[btn];
			}
		}
		
		/**
		 * 点击被注册的按钮 
		 * @param e
		 * 
		 */
		private static function onClickBtn(e:MouseEvent):void
		{
			var btn:InteractiveObject = e.target as InteractiveObject;
			_currentBtn = btn;
			if(ColorSelector.instance.parent)
			{
				hide();
			}
			else
			{
				var p:Point = btn.parent.localToGlobal(new Point(btn.x,btn.y));
				ColorSelector.instance.x = p.x;
				ColorSelector.instance.y = p.y - 120;
				LayerManager.toolTipLayer.addChild(ColorSelector.instance);
				Global.instance.callLater(addFrameClickStage);
			}
		}
		
		private static function hide():void
		{	
			ColorSelector.instance.parent.removeChild(ColorSelector.instance);
			Global.stage.removeEventListener(MouseEvent.CLICK,onClickStage);
		}
		
		
		private static function addFrameClickStage():void
		{
			Global.stage.addEventListener(MouseEvent.CLICK,onClickStage);
		}
		
		private static function onClickStage(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			
			if(target != _currentBtn && target != ColorSelector.instance && !ColorSelector.instance.contains(target))
			{
				if(ColorSelector.instance.parent)
				{
					hide();
				}
			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			var yPos:int = 0;
			var arrLength:int = colorArr.length;
			for(var i:int=0; i<arrLength; i++)
			{
				var colorItem:ColorItem = new ColorItem(colorArr[i]);
				colorItem.x = 0;
				colorItem.y = yPos;
				yPos = yPos + colorItem.height;
				colorItem.addEventListener(EventName.ChatColorSelect, onChatColorSelectHandler);
				addChild(colorItem);
			}
		}
		
		private function onChatColorSelectHandler(e:DataEvent):void
		{
			(_dicbtnCallback[_currentBtn] as Function).call(null,e.data);
			hide();
		}
	}
}