package view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.FriendDataReader;
	import model.FriendInfo;
	
	public class FriendList extends Sprite
	{
		private var _minLength:int = 12;
		private var _friendList:Array;
		private var _showList:Array = [];
		private var _backList:Array = [];
		private var _listSprite:Sprite;
		private var _itemPool:Array = [];
		
		private const _speedFrist:int = 11;
		private const _acceleration:Number = -1.02;
		private var _speed:Number = 10;
		private var _dirction:int = 1;
		private var _rolling:Boolean;
		
		private var _loader:URLLoader;
		
		private var _splitLine:Bitmap;
		private var _friendFont:Bitmap;
		private var _leftBtn:SimpleButton;
		private var _rightBtn:SimpleButton;
		
		private var _layer:DisplayObjectContainer;
		private var _hide:Boolean;
		
		private var _loadCount:int = 0;
		private var _url1:String;
		private var _url2:String;
		
		public function FriendList(layer:DisplayObjectContainer)
		{
			super();
			_layer = layer;
			
			_splitLine = new Bitmap(new friendLine());
			_splitLine.x = (width - _splitLine.width)/2;
			addChild(_splitLine);
			
			_friendFont = new Bitmap(new friendFont());
			_friendFont.y = 15;
			_friendFont.x = (width - _friendFont.width)/2;
			addChild(_friendFont);
			
			_leftBtn = new leftBtn();
			_leftBtn.x = -_leftBtn.width - 5;
			_leftBtn.y = 60;
			addChild(_leftBtn);
			
			_rightBtn = new rightBtn();
			_rightBtn.x = width + 5;
			_rightBtn.y = _leftBtn.y;
			addChild(_rightBtn);
			
			_listSprite = new Sprite();
			_listSprite.y = _leftBtn.y - 10;
			addChild(_listSprite);
			
			_rightBtn.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			_leftBtn.addEventListener(MouseEvent.CLICK,onMouseClickHandler);
			
			_listSprite.scrollRect = new Rectangle(0,0,width,height);
			
//			graphics.lineStyle(2,0xff0000,1)
//			graphics.beginFill(0x00ff00,0);
//			graphics.drawRect(0,0,width,height);
//			graphics.endFill();
		}
		
		public function show():void
		{
			if(_layer && !parent)
			{
				_hide = false;
				_layer.addChildAt(this,0);
			}
		}
		
		public function hide():void
		{
			if(_loadCount == 1)
			{
				loadUrl(_url2);
			}
			else
			{
				if(this.parent)
				{
					_hide = true;
					this.parent.removeChild(this);
				}
			}
		}
		
		public function get isHide():Boolean
		{
			return _hide;
		}
		
		private function onMouseClickHandler(event:MouseEvent):void
		{
			if(event.target is leftBtn)
			{
//				rollLeft();
				rollRight();
			}
			else if(event.target is rightBtn)
			{
				rollLeft();
//				rollRight();
			}
		}
		
		public function updateUrl(url1:String,url2:String):void
		{
			_url1 = url1;
			_url2 = url2;
			if(!_loader)
			{
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE,onUrlLoadedComHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR,onUrlLoadedErrorHandler);
			}
			loadUrl(_url1);
		}
		
		private function loadUrl(url:String):void
		{
			_loadCount++;
			if(url && url != "")
			{
				_loader.load(new URLRequest(url));
			}
			else
			{
				hide();
			}
		}
		
		private function onUrlLoadedComHandler(event:Event):void
		{
			try
			{
				updateData(FriendDataReader.parserJson(_loader.data));
			}
			catch(e:Event)
			{
				hide();
			}
		}
		
		private function onUrlLoadedErrorHandler(event:IOErrorEvent):void
		{
			hide();
		}
		
		public function updateData(list:Array):void
		{
			if(!list || list.length == 0)
			{
				hide();
				return;
			}
			
			if(_layer && !parent)
			{
				_layer.addChildAt(this,0);
			}
			
			_friendList = list;
			var index:int;
			var length:int = _friendList.length;
			while(length < _minLength)
			{
				index = _minLength - length;
				if(index > length)
				{
					index = length;
				}
				_friendList = _friendList.concat(_friendList.slice(0,index));
				length = _friendList.length;
			}
			
			index = 0;
			length = _minLength;
			var item:FriendItem;
			var info:FriendInfo;
			while(index < length)
			{
				info = _friendList[index];
				item = new FriendItem();
				item.updateData(info);
				_showList.push(item);
				item.x = -item.width + index * item.width;
				_listSprite.addChild(item);
				index++;
			}
			_backList = _friendList.slice(_minLength,_friendList.length);
		}
		
		private function rollLeft():void
		{
			_dirction = -1;
			beginRoll();
		}
		
		private function rollRight():void
		{
			_dirction = 1;
			beginRoll();
		}
		
		private function beginRoll():void
		{
			if(!_rolling)
			{
				_speed = _speedFrist;
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
				_rolling = true;
			}
		}
		
		private function endRoll(relayer:Boolean=true):void
		{
			if(_rolling)
			{
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				_rolling = false;
				
				if(relayer)
				{
					var index:int;
					var length:int = _showList.length;
					var item:FriendItem;
					while(index < length)
					{
						item = _showList[index];
						item.x = -item.width + index * item.width;
						index++;
					}
				}
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			var index:int = 0;
			var length:int = _showList.length;
			var item:FriendItem;
			while(index < length)
			{
				item = _showList[index];
				item.x += _speed * _dirction;
				index++;
			}
			
			index = 0;
			while(index < length)
			{
				item = _showList[index];
				if(boundaryDetection(item))
				{
					updateShowList(item,index);
				}
				index++;
			}
			_speed += _acceleration;
			trace(_speed);
			if(_speed <= 0)
			{
				endRoll();
			}
		}
		
		private function boundaryDetection(item:FriendItem):Boolean
		{
			if(_dirction < 0)
			{
				if(item.x < -item.width)
				{
					trace(item.x);
					return true;
				}
			}
			else
			{
				if(item.x > width + item.width + 5)
				{
					trace(item.x);
					return true;
				}
			}
			return false;
		}
		
		private function updateShowList(item:FriendItem,index:int):void
		{
			_showList.splice(index,1);
			_backList.push(item.info);
			item.updateData(_backList.shift());
			if(_dirction > 0)
			{
				_showList.unshift(item);
				item.x = item.x - _minLength * item.width;
			}
			else
			{
				_showList.push(item);
				item.x = item.x + _minLength * item.width;
			}
		}
		
		override public function get width():Number
		{
			return 580;
		}
		
		override public function get height():Number
		{
			return 130;
		}
	}
}