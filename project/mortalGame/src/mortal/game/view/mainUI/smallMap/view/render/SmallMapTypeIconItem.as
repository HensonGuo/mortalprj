/**
 * 2014-1-22
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.model.BossAreaInfo;
	import mortal.game.model.NPCInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapTypeIconData;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapTypeIconItem extends GSprite implements IToolTipItem
	{
		private var _icon:GBitmap;
		private var _tips:String = "test";
		private var _data:SmallMapTypeIconData;
		
		public function SmallMapTypeIconItem()
		{
			super();
		}
		
		public function updateData(data:SmallMapTypeIconData):void
		{
			_icon.bitmapData = GlobalClass.getBitmapData(data.iconName);
			_data = data;
			if(data.tips != null)
			{
				_tips = data.tips;
				this.mouseEnabled = true;
				this.mouseChildren = true;
			}
			else
			{
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
			
			this.x = data.x * data.scale - _icon.width/2;
			this.y = data.y * data.scale - _icon.height/2;
		}
		
		/**
		 * 获取tooltip数据 
		 * @return 
		 */
		public function get toolTipData():*
		{
			return _tips;
		}
		/**
		 * 设置tooltip数据 
		 * @param value
		 */		
		public function set toolTipData(value:*):void
		{
			
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_icon = UIFactory.gBitmap("", 0, 0, this);
			
			this.configEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.configEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			
			
			// 监听事件
			this.mouseEnabled = true;
			this.doubleClickEnabled = true;
			this.configEventListener(MouseEvent.CLICK, clickHandler);
			this.configEventListener(MouseEvent.DOUBLE_CLICK, flyToHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			
			_icon = null;
		}
		
		private function addToStageHandler(evt:Event):void
		{
			ToolTipsManager.register(this);
		}
		
		private function removeFromStageHandler(evt:Event):void
		{
			ToolTipsManager.unregister(this);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var gotoX:int = _data.x;
			var gotoY:int = _data.y;
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapClick, {"x":gotoX, "y":gotoY}));
		}
		
		private function flyToHandler(evt:MouseEvent):void
		{
			var gotoX:int = _data.x;
			var gotoY:int = _data.y;
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapDoubleClick, {"x":gotoX, "y":gotoY}));
		}
	}
}