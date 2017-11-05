package mortal.game.view.wizard
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.net.CallLater;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class GTabarNew extends GSprite
	{
		private var _tab:GTabBar;
		
		private var _leftLine:ScaleBitmap;
		
		private var _rightLine:ScaleBitmap;
		
		public function GTabarNew()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_leftLine = GlobalClass.getScaleBitmap(ImagesConst.LeftWinLine,new Rectangle(6,0,1,1));
			this.addChild(_leftLine);
			
			_rightLine = GlobalClass.getScaleBitmap(ImagesConst.rightWinLine,new Rectangle(2,0,1,1));
			this.addChild(_rightLine);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_leftLine.dispose(isReuse);
			_leftLine = null;
			
			_rightLine.dispose(isReuse);
			_rightLine = null;
			
			_tab.dispose(isReuse);
			_tab = null;
		}
		
		
		public function setWidth(value:Number):void
		{
			_width = value;
			
			CallLater.addCallBack(updateLinePos);
		}
		
		public function set dataProvider(arr:Array):void
		{
			_tab = UIFactory.gTabBar(6,0,arr,72,22,this,changeHandler,"TabButtonNew");
		}
		
		public function set buttonWidth(value:Number):void
		{
			_tab.buttonWidth = value;
		}
		
		public function set buttonHeight(value:Number):void
		{
			_tab.buttonHeight = value;
		}
		
		public function set buttonStyleName(str:String):void
		{
			_tab.buttonStyleName = str;
		}
		
		public function set horizontalGap(value:int):void
		{
			_tab.horizontalGap = value;
		}
		
		public function set buttonFilters(arr:Array):void
		{
			_tab.buttonFilters = arr;
		}
		
		public function set selectedIndex(value:int):void
		{
			_tab.selectedIndex = value;
		}
		
		public function get selectedIndex():int
		{
			return _tab.selectedIndex;
		}
		
		public function get tab():GTabBar
		{
			return _tab;
		}
		
		public function drawNow():void
		{
			_tab.drawNow();
		}
		
		private function updateLinePos():void
		{
			_leftLine.y = _tab.buttonHeight - 2;
			_leftLine.width = 10 + _tab.selectedIndex*(_tab.horizontalGap + _tab.buttonWidth);
			
			_rightLine.y = _tab.buttonHeight - 2;
			_rightLine.x = 6 + _tab.selectedIndex*(_tab.horizontalGap + _tab.buttonWidth) + _tab.buttonWidth;
			_rightLine.width = _width - _rightLine.x + 2;
		}
		
		private function changeHandler(e:MuiEvent = null):void
		{
			updateLinePos();
			dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE,_tab.selectedIndex));
		}
		
		
	}
}