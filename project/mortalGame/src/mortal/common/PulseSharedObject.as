package mortal.common
{
	import com.gengine.manager.CacheManager;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.manager.ClockManager;

	public class PulseSharedObject
	{
		private static const Pulse_NotTip:String = "pulse/Pulse_NotTip";
		
		private static var _userDataObj:Object;
		
		private static var _sharedObject:SharedObject;
		
		private static var _isCache:Boolean = true;
		
		public function PulseSharedObject()
		{
		}
		
		public static function save(type:String,isSave:Boolean):void
		{
			if( _isCache == false ) return;
			var userName:String = ParamsConst.instance.username;
			var date:Date = ClockManager.instance.nowDate;
			if( isSave == false )
			{
				date = null;
			}
			getSharedObject();
			_userDataObj[userName+"_"+type] = date;
			_sharedObject.data.userDataObj = _userDataObj;
//			so.flush(10000);
		}
		
		public static function isTodayNotTips(type:String):Boolean
		{
			if( _isCache == false ) return false;
			var userName:String = ParamsConst.instance.username;
			var date:Date = ClockManager.instance.nowDate;
			getSharedObject();
			if(_userDataObj[userName+"_"+type])
			{
				var oldDate:Date = _userDataObj[ userName+"_"+type ] as Date;
				if(oldDate!=null && oldDate.date == date.date && oldDate.month==date.month && oldDate.fullYear == date.fullYear)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 *保存键值 
		 * @param key
		 * @param value
		 * 
		 */		
		public static function saveValue(key:String,value:Object):void
		{
			if( _isCache == false ) return;
			var userName:String = ParamsConst.instance.username;
			getSharedObject();
			_userDataObj[userName+"_"+key] = value;
			_sharedObject.data.userDataObj = _userDataObj;
//			so.flush(10000);
		}
		
		/**
		 *获取保存的值 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function getValue(key:String):Object
		{
			var userName:String = ParamsConst.instance.username;
			getSharedObject();
			return _userDataObj[ userName+"_"+key ];
		}
		
		private static function getSharedObject():void
		{
			if( _sharedObject == null )
			{
				_sharedObject =  CacheManager.instance.getLocal(Pulse_NotTip);
				_sharedObject.addEventListener(NetStatusEvent.NET_STATUS,onNetStatusEvent);
			}
			if( _userDataObj==null)
			{
				_userDataObj = _sharedObject.data.userDataObj;
				if( _userDataObj == null )
				{
					_userDataObj={};
				}
			}
		}
		
		private static function onNetStatusEvent(e:NetStatusEvent):void 
		{
			if (e.info.code == "SharedObject.Flush.Failed") 
			{
				_isCache = false;
			}
			else 
			{
				_isCache =true;
			}
		}
	}
}