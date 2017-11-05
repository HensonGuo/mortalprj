/**
 * 2014-1-23
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapCustomXYData;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapCustomXYRender extends GCellRenderer
	{
		private var _txtName:GTextFiled;
		private var _btnFlyBoot:GLoadedButton;
		private var _line:ScaleBitmap;
		private var _myData:SmallMapCustomXYData;
		
		public function SmallMapCustomXYRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData= value as SmallMapCustomXYData;
			
			if(_myData.isNotSet)
			{
				_txtName.textColor = 0x696969;
			}
			else
			{
				_txtName.textColor = GlobalStyle.colorPutongUint;
			}
			_txtName.text = _myData.name;
			if(_myData.mapId > 0)
			{
				_txtName.toolTipData = GameMapConfig.instance.getMapInfo(_myData.mapId).name + "(" + _myData.x.toString() 
					+ ", " + _myData.y.toString() + ")";
			}
//			_txtName.mouseEnabled = !_myData.isNotSet;
			this.buttonMode = true;//!_myData.isNotSet;
		}
		
		private function clickNameTextHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapClick, {"x":_myData.x, "y":_myData.y}));
		}
		
		private function mouseOverTextHandler(evt:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function mouseOutTextHandler(evt:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.underline = true;
			tf.size = 13;
			_txtName = UIFactory.gTextField("", 4, 3, 200, 24, this, tf);
			_btnFlyBoot = UIFactory.gLoadedButton(ImagesConst.MapBtnFlyBoot_upSkin, 150, 0, 16, 18, this);
		
			_line = UIFactory.bg(-8, 24, 200, 1, this, ImagesConst.SplitLine);
			_btnFlyBoot.configEventListener(MouseEvent.CLICK, flyReqHandler);
			
			this.configEventListener(MouseEvent.CLICK, clickMeHandler);
			_txtName.configEventListener(MouseEvent.CLICK, clickNameTextHandler);
			_txtName.configEventListener(MouseEvent.MOUSE_OVER, mouseOverTextHandler);
			_txtName.configEventListener(MouseEvent.MOUSE_OUT, mouseOutTextHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_txtName.dispose(isReuse);
			_btnFlyBoot.dispose(isReuse);
			_line.dispose(isReuse);
			
			_txtName = null;
			_btnFlyBoot = null;
			_line = null;
		}
		
		private function flyReqHandler(evt:MouseEvent):void
		{
			if(_myData == null || _myData.isNotSet)
			{
				return;
			}
			var pt:SPassTo = new SPassTo();
			pt.toPoint = new SPoint();
			pt.toPoint.x = _myData.x;
			pt.toPoint.y = _myData.y;
			pt.mapId = _myData.mapId;
			Dispatcher.dispatchEvent(new DataEvent(EventName.FlyBoot, pt));
		}
		
		private function clickMeHandler(evt:MouseEvent):void
		{
			if(_myData == null || _myData.isNotSet)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowCustomMapPoinWin));
				return;
			}
		}
	}
}