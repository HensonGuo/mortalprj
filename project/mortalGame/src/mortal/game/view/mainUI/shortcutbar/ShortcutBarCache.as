/**
 * 2014-1-13
 * @author chenriji
 **/
package mortal.game.view.mainUI.shortcutbar
{
	import Message.Public.EClientSetType;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.Dispatcher;

	public class ShortcutBarCache
	{
		private var _obj:Object = {};
		private var _lastKeyDownPos:int = -1;
		public var isLastKeyByClick:Boolean = false;
		
		public var isLocked:Boolean = false;
		public var isShowCDTime:Boolean = true;
		
		public function ShortcutBarCache()
		{
		}
		
		/**
		 * 上次按下键盘的位置，在放上的时候会重置 
		 */
		public function get lastKeyDownPos():int
		{
			return _lastKeyDownPos;
		}

		/**
		 * @private
		 */
		public function set lastKeyDownPos(value:int):void
		{
			_lastKeyDownPos = value;
		}

		public function initData(str:String):void
		{
			if(str == null || str == "")
			{
				// 设置默认
				return;
			}
			_obj = JSON.parse(str);
		}
		
		public function get shortcutBarDatas():Object
		{
			return _obj;
		}
		
		public function addShortCut(pos:int, type:int, value:Object):void
		{
			_obj[pos] = {"t":type, "v":value};
			var obj:Object = {"pos":pos, "t":type, "v":value};
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarDataChange, obj));
		}
		
		public function getData(pos:int):Object
		{
			return _obj[pos];
		}
		
		public function removeShortcut(pos:int):void
		{
			_obj[pos] = null;
			delete _obj[pos];
		}
		
		public function save():void
		{
			var obj:Object = {};
			obj["type"] = SystemSettingType.ShortcutBarData;
			obj["value"] = JSON.stringify(_obj);
			Dispatcher.dispatchEvent(new DataEvent(EventName.SystemSettingSava, obj));
		}
	}
}