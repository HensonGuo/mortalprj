package mortal.game.view.chat.chatTrumpet
{
	import flash.display.Sprite;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	
	public class ColorPanel extends Sprite
	{
		public function ColorPanel()
		{
			super();
			var colorArr:Array = new Array(0xFFCC00,0xFFFFF00,0x00FF00,0x0000FF,0xFF00FF);
			init(colorArr);
		}
		
		private function init(colorArr:Array):void
		{
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
			dispatchEvent(new DataEvent(EventName.ChatColorSelect, e.data));
		}
	}
}