package mortal.game.view.common.display
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ItemConfig;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class TextInputList extends GSprite
	{
		public var _textInput:GTextInput;
		public var _tileList:GTileList;
		public var _bg:ScaleBitmap;
		public var _listContainer:GSprite;
		
		public var defultString:String = "请输入搜索关键字";
		public var textChangeCallBack:Function;
		public var selectdata:Object;
		public function TextInputList()
		{
			super();
		}
		
		private function onAddToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStageHandler);
			
			if(_listContainer && _listContainer.parent != LayerManager.topLayer)
			{
				var point:Point = _listContainer.parent.localToGlobal(new Point(_listContainer.x,_listContainer.y));
				LayerManager.topLayer.addChild(_listContainer);
				_listContainer.move(point.x,point.y);
			}
			
			Global.stage.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageHandler);
		}
		
		private function onRemoveFromStageHandler(e:Event):void
		{
			Global.stage.removeEventListener(MouseEvent.CLICK, onMouseClickHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStageHandler);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			var _tf:GTextFormat = GlobalStyle.textFormatBai;
			_tf.align = TextFormatAlign.LEFT;
			_textInput = UIFactory.gTextInput(0,0,140,22,this);
			_textInput.setStyle("textFormat" ,  _tf);
			_textInput.text = "";
			
			_listContainer = UIFactory.getUICompoment(GSprite,0,22,this);
			
			_bg = UIFactory.bg(0,0,140,140,_listContainer);
			
			_tileList = UIFactory.tileList(0,0,140,140,_listContainer);
			_tileList.columnWidth = 140;
			_tileList.rowHeight = 20;
			_tileList.direction = ScrollBarDirection.VERTICAL;
			_tileList.horizontalGap = 0;
			_tileList.verticalGap = 0;
			_tileList.styleName = "TileList";
			_tileList.setStyle("skin",new Bitmap());
			_tileList.setStyle("cellRenderer",TextInputListRenderer);
			
			
			
			_tileList.configEventListener(Event.CHANGE,lisetSecletHandler);
			_textInput.configEventListener(Event.CHANGE, onTextInputChangeHandler);
			_textInput.configEventListener(FocusEvent.FOCUS_IN, onTextInputFocusInHandler);
			_textInput.configEventListener(FocusEvent.FOCUS_OUT,onTextInputFocusOutHandler);
			
			onTextInputFocusOutHandler(null);
			onMouseClickHandler(null);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddToStageHandler);
		}
		
		public function init(_textChangeCallBack:Function):void
		{
			this.textChangeCallBack = _textChangeCallBack;
		}
		
		private function lisetSecletHandler(e:Event):void   //选中改变
		{
			_textInput.text = _tileList.selectedItem.name;
			selectdata = _tileList.selectedItem;
		}
		
		protected function onTextInputChangeHandler(e:Event):void
		{
			selectdata = null;
			if(textChangeCallBack != null)
			{
				textChangeCallBack();
			}
		}
		
		protected function onTextInputFocusInHandler(e:FocusEvent):void
		{
			if(_textInput == null)
			{
				return;
			}
			
			if(_textInput.text!="" && _textInput.text==defultString)
			{
				_textInput.text = "";
			}
		}
		
		protected function onTextInputFocusOutHandler(e:FocusEvent):void
		{
			if(_textInput.text=="")
			{
				_textInput.text = defultString;//"输入搜索关键字";
			}
			
//			_bg.visible = false;
//			_tileList.visible = false;
			//_tileList.mouseEnabled = _tileList.mouseChildren  = false;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			textChangeCallBack = null;
			
			_tileList.removeEventListener(Event.CHANGE,lisetSecletHandler);
			_textInput.removeEventListener(Event.CHANGE, onTextInputChangeHandler);
			_textInput.removeEventListener(FocusEvent.FOCUS_IN, onTextInputFocusInHandler);
			_textInput.removeEventListener(FocusEvent.FOCUS_OUT,onTextInputFocusOutHandler);
			
			
			_textInput.dispose(isReuse);
			_tileList.mouseEnabled = _tileList.mouseChildren  = true;
			_tileList.dispose(isReuse);
			_bg.dispose(isReuse);
			_listContainer.dispose(isReuse);
			
			_textInput = null;
			_tileList = null;
			_bg = null;
			_listContainer = null;
		}
		
		public function updateDataProvider(dp:DataProvider):void
		{
			_tileList.dataProvider = dp;
			if(dp.length<7)
			{
				_bg.height = dp.length * 20;
			}
			else
			{
				_bg.height = 140;
			}
			
			if(dp.length>0)
			{
				_bg.visible = true;
				_tileList.visible = true;
				_tileList.mouseEnabled = _tileList.mouseChildren  = true;
			}
		}
		
		public function updateDataProvider1(itemArr:Array):void
		{
			updateDataProvider(new DataProvider(itemArr));
		}
		
		protected function onMouseClickHandler(e:MouseEvent):void
		{
			_bg.visible = false;
			_tileList.visible = false;
			_tileList.mouseEnabled = _tileList.mouseChildren  = false;
		}
		
		
	}
}