/**
 * 2014-1-21
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view.render
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapShowItem extends GSprite
	{
		private var _icon:GBitmap;
		private var _txt:GTextFiled;
		private var _box:GCheckBox;
		private var _line:ScaleBitmap;
		private var _type:uint;
		
		public function SmallMapShowItem()
		{
			super();
		}
		
		public function updateData(obj:Object):void
		{
			var url:String = obj["icon"];
			var name:String = obj["name"];
			var selected:Boolean = !ClientSetting.local.getIsDone(uint(obj["type"]));
			_type = uint(obj["type"]);
			_icon.bitmapData = GlobalClass.getBitmapData(url);
			_txt.text = name;
			_box.selected = selected;
			
			_box.configEventListener(Event.CHANGE, selectedChangeHandler);
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowTypeChange, {"type":_type, "value":!_box.selected}));
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_icon = UIFactory.gBitmap("", 0, 0, this);
			_txt = UIFactory.gTextField("", 22, 0, 160, 20, this);
			_box = UIFactory.checkBox("", 140, 2, 16, 16, this);
			_line = UIFactory.bg(0, 21, 180, 1, this, ImagesConst.SplitLine);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			_txt.dispose(isReuse);
			_box.dispose(isReuse);
			_line.dispose(isReuse);
			
			_icon = null;
			_txt = null;
			_box = null;
			_line = null;
			
		}
	}
}