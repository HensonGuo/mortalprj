package mortal.game.view.group
{
	import com.mui.containers.GBox;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GImageBitmap;
	import com.mui.core.GlobalClass;
	
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	public class GroupIcon extends View
	{
		private static var _tabIndex:int;
		
		private var _icon:GBitmap;
		
		public function GroupIcon()
		{
			super();
			this.layer = LayerManager.smallIconLayer;
			this.mouseChildren = false;
			this.buttonMode = true;
			this.mouseEnabled = true;
		}
		
		private static var _instance:GroupIcon;
		
		
		public static function get instance():GroupIcon
		{
			if(!_instance)
			{
				_instance = new GroupIcon();
			}
			return _instance;
		}
		
		public static function set tabIndex(value:int):void
		{
			_tabIndex = value;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			
			_icon = UIFactory.gBitmap("",0,0,this);
			
			setIcon(_tabIndex);
			
			this.configEventListener(MouseEvent.CLICK,openGroupWin);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_icon.dispose();
			_icon = null;
		}
		
		private function setIcon(value:int):void
		{
			var url:String;
			switch(value)
			{
				case 3:
					url = ImagesConst.FriendHintIcon;
					break;
				case 4:
					url = ImagesConst.GroupHintIcon;
					break;
			}
			_icon.bitmapData = GlobalClass.getBitmapData(url);
		}
		
		private function openGroupWin(e:MouseEvent):void
		{
			GameManager.instance.popupWindow(ModuleType.Group);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupTabIndexChange , _tabIndex));
			GroupIcon.instance.hide();
		}
	}
}