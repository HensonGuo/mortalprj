package mortal.game.view.common.button
{
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.events.SortEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class SortButton extends GSprite
	{
		public static const MODE_DESCENDING:int = 1;//降序
		public static const MODE_ASCENDING:int = 2;//升序
		
		private var _btn:GLoadedButton;
		private var _mode:int;
		
		public function SortButton()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_btn = UIFactory.gLoadedButton(ImagesConst.descendingSortBtn_upSkin,0,0,11,14,this);
			_btn.configEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_btn.dispose();
			_btn = null;
			_mode = MODE_DESCENDING;
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			_btn.styleName = _btn.styleName == ImagesConst.descendingSortBtn_upSkin
				? ImagesConst.ascendingSortBtn_upSkin : ImagesConst.descendingSortBtn_upSkin;
			
			if (_btn.styleName == ImagesConst.descendingSortBtn_upSkin)
			{
				this.dispatchEvent(new SortEvent(SortEvent.DESCENDING));
			}
			else
			{
				this.dispatchEvent(new SortEvent(SortEvent.ASCENDING));
			}
		}
		
		public function get mode():int
		{
			return _mode;
		}
		
		public function set mode(mode:int):void
		{
			_mode = mode;
		}
		
	}
}