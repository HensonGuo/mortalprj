package view
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import model.FriendInfo;
	
	public class FriendItem extends Sprite
	{
		private var _border:Bitmap;
		private var _info:FriendInfo;
		private var _text:TextField;
		private var _loader:Loader;
		
		public function FriendItem()
		{
			super();
			
			_border = new Bitmap(new headBorder());
			addChild(_border);
			
//			graphics.beginFill(0x00ff00,1);
//			graphics.drawRect(0,0,50,50);
//			graphics.endFill();
		
			_text = new TextField();
			_text.width = width;
			_text.height = 20;
			_text.textColor = 0xffff00;
			_text.y = 60;
			addChild(_text);
			
			_loader = new Loader();
			_loader.addEventListener(Event.COMPLETE,onImgLoadedComHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onImgLoadedErrorHandler);
			_loader.x = 5;
			_loader.y = 5;
			addChild(_loader);
		}
		
		private function onImgLoadedComHandler(event:Event):void
		{
			trace(event.toString());
		}
		
		private function onImgLoadedErrorHandler(event:IOErrorEvent):void
		{
			trace(event.toString());
		}
		
		public function updateData(info:FriendInfo):void
		{
			_info = info;
			_text.text = info.name;
			_text.x = (_border.width - _text.textWidth)/2;
			_loader.load(new URLRequest(info.img));
		}
		
		public function get info():FriendInfo
		{
			return _info;
		}
		
		override public function get width():Number
		{
			return _border.width + 5;
		}

		override public function get height():Number
		{
			return _border.height;
		}
	}
}