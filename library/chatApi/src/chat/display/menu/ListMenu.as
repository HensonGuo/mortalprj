package chat.display.menu
{
	import com.mui.controls.GList;
	import com.mui.controls.GUIComponent;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ComponentEvent;
	import fl.events.ListEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	public class ListMenu extends GUIComponent
	{
		
		private var _bg:ScaleBitmap;
		private var _list:List;
		private var _delayTimer:Timer;
		
		public function ListMenu(bgScaleBitmap:ScaleBitmap = null)
		{
			super();
			
			setSize(86,121);
			_bg = this.addChild(getScaleBg()) as ScaleBitmap;
			
			_list = new List();
			_list.x = -4;
			_list.y = 10;
			_list.rowHeight = 18;
			_list.horizontalScrollPolicy = "off";
			_list.verticalScrollPolicy = "off";
			_list.setStyle("skin",new Bitmap());
			_list.setStyle("cellRenderer",ListMenuCellRenderer);
			_list.addEventListener(ListEvent.ITEM_CLICK,itemClickHandler);
			this.addChild(_list);
		}
		
		
		public static function getScaleBg():ScaleBitmap
		{
			var bmd:BitmapData = new ToolTipBg(40,29);
			if(bmd != null)
			{
				var sb:ScaleBitmap = new ScaleBitmap(bmd.clone());
				sb.scale9Grid = new Rectangle(10,10,20,9);
				return sb;
			}
			return null;
		}
		
		private var _dataProvider:DataProvider;
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}
		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
			
			_list.dataProvider = value;
			
			_list.height = value.length*_list.rowHeight;
			this.height = _list.height + 21;
		}
		
		private var _target:DisplayObject;
		public function set target(value:DisplayObject):void
		{
			_target = value;
		}
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function hide():void
		{
			this.visible = false;
			
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}
			
			_list.clearSelection();
		}
		
		public function show(x:Number,y:Number,target:DisplayObject):void
		{
			this.x = x;
			this.y = y;
			this.target = target;
			
			if(!hasEventListener(MouseEvent.MOUSE_OVER))
			{
				this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			}
			
			if(!_delayTimer)
			{
				_delayTimer = new Timer(3000);
				_delayTimer.addEventListener(TimerEvent.TIMER,delayTimerHandler);
				_delayTimer.start();
			}
			else
			{
				_delayTimer.reset();
				_delayTimer.start();
			}
			
			this.visible = true;
		}
		
		private function enterFrameHandler(e:Event):void
		{
			if(!_bg.hitTestPoint(stage.mouseX,stage.mouseY,true))
			{
				hide();
			}
		}
		private function mouseOverHandler(e:MouseEvent):void
		{
			_delayTimer.stop();
			_delayTimer.removeEventListener(TimerEvent.TIMER,delayTimerHandler);
			_delayTimer = null;
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		private function delayTimerHandler(e:TimerEvent):void
		{
			_delayTimer.stop();
			_delayTimer.removeEventListener(TimerEvent.TIMER,delayTimerHandler);
			_delayTimer = null;
			
			hide();
		}
		
		private function itemClickHandler(e:ListEvent):void
		{
			switch(e.item)
			{
				case "":
					break;
			}
			
			hide();
		}
		
		public function get list():List
		{
			return this._list;
		}
		
		override public function set width(arg0:Number):void
		{
			super.width = arg0;
			
			_bg.width = arg0;
		}
		override public function set height(arg0:Number):void
		{
			super.height = arg0;
			
			_bg.height = arg0;
		}
		
//		public function dispose():void
//		{
//			
//		}
	}
}