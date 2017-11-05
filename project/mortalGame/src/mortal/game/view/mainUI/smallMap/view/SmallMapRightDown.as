/**
 * 2014-1-21
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLabel;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.control.subControl.Scene3DClickProcessor;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapCustomXYRender;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapRightDown extends GSprite
	{
		private var _titleBg:ScaleBitmap;
		private var _title:GBitmap;
		private var _list:GTileList;
		private var _btnFix:GButton;
		private var _line:ScaleBitmap;
		private var _txtMouseXY:GTextFiled;
		private var _lX:GLabel;
		private var _txtX:GTextInput;
		private var _lY:GLabel;
		private var _txtY:GTextInput;
		private var _btnGo:GButton;
		
		private var _myData:DataProvider;
		
		public function SmallMapRightDown()
		{
			super();
		}
		
		public function updateDatas(data:DataProvider):void
		{
			_myData = data;
			_list.dataProvider = data;
			_list.drawNow();
		}
		
		public function updateMouseXY(x:int, y:int):void
		{
			_txtMouseXY.text = Language.getStringByParam(20074, x, y);
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_titleBg = UIFactory.bg(1, 1, 193, 26, this, ImagesConst.RegionTitleBg);
			_title = UIFactory.gBitmap(ImagesConst.MapPic_ZDYZB, 10, 7, this);
			
			_list = UIFactory.tileList(8, 28, 185, 180, this);
			_list.setStyle("cellRenderer", SmallMapCustomXYRender);
			_list.rowHeight = 25;
			_list.columnWidth = 190;
			_list.direction = GBoxDirection.VERTICAL;
			
			_btnFix = UIFactory.gButton(Language.getString(20073), 67, 161, 55, 20, this);
			_line = UIFactory.bg(4, 193, 190, 1, this, ImagesConst.SplitLine);
		
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.color = 0xFABC8B;
			tf.align = TextFormatAlign.CENTER;
			_txtMouseXY = UIFactory.gTextField(Language.getStringByParam(20074, 0, 0), 0, 200, 195, 20, this, tf);
			
			
			_lX = UIFactory.label("X:", 7, 227, 30, 24, TextFormatAlign.LEFT, this);
			_txtX = UIFactory.gTextInput(22, 226, 45, 20, this);
			_lY = UIFactory.label("Y:", 70, 227, 30, 24, TextFormatAlign.LEFT, this);
			_txtY = UIFactory.gTextInput(82, 226, 45, 20, this);
			_txtX.restrict = "0-9";
			_txtX.maxChars = 5;
			_txtY.restrict = "0-9";
			_txtY.maxChars = 5;
			
			_btnGo = UIFactory.gButton(Language.getString(20075), 140, 224, 49, 20, this);
			
			_btnFix.configEventListener(MouseEvent.CLICK, fixHandler);
			_btnGo.configEventListener(MouseEvent.CLICK, gotoPointHandler);
		}
		
		private function fixHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowCustomMapPoinWin));
		}
		
		private function gotoPointHandler(evt:MouseEvent):void
		{
			var xx:int = int(_txtX.text);
			var yy:int = int(_txtY.text);
			var p:Point = new Point(xx, yy);
			Scene3DClickProcessor.gotoPoint(p, true, 0);
			
			_txtX.text = "";
			_txtY.text = "";
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_titleBg.dispose(isReuse);
			_title.dispose(isReuse);
			_list.dispose(isReuse);
			_btnFix.dispose(isReuse);
			_btnGo.dispose(isReuse);
			_txtMouseXY.dispose(isReuse);
			_line.dispose(isReuse);
			
			_lX.dispose(isReuse);
			_txtX.dispose(isReuse);
			_lY.dispose(isReuse);
			_txtY.dispose(isReuse);
			
			_titleBg = null;
			_title = null;
			_line = null;
			_list = null;
			_btnFix = null;
			_btnGo = null;
			_txtMouseXY = null;
			_lX = null;
			_txtX = null;
			_lY = null;
			_txtY = null;
			
		}
	}
}