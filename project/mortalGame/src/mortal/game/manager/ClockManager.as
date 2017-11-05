/**
 * @date	2011-4-19 下午05:30:19
 * @author  jianglang
 * 
 * 时钟管理
 * 
 *  addDateCall( date:Date , callback:Function ) //添加一个时间点 执行函数
	removeDateCall(date:Date)//* 删除已个时间点 
	setNowTimer( time:Object ) //时间服务器当前时间
	get nowDate():Date//获取当前时间
	TimeEvent.DateChange  // 时间天数发生改变的事件
 */	

package mortal.game.manager
{
	import com.gengine.global.Global;
	import com.gengine.ui.timer.GameClock;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	
	import mortal.game.events.TimeEvent;
	
	[Event(name="dataChange",type="mortal.game.events.TimeEvent")]
	[Event(name="ServerOpenDayChange",type="mortal.game.events.TimeEvent")]
	
	public class ClockManager extends EventDispatcher
	{
		private  var _gameClock:GameClock;
		
		private const DayTime:Number = 1000*60*60*24;//一天多少毫秒
		
		private var _roleCreateDate:Date;
		
		private var _timeMap:Dictionary = new Dictionary();
		
//		private var _executed:Dictionary = new Dictionary();
		
		private var _serverDate:Date;
		
		private static var _instance:ClockManager;
		
		private var _serverOpenDate:Number=0;//开服时间秒数 
		
		private var _serverOpenDateNum:int;//开服天数
		
		public function ClockManager()
		{
			if( _instance != null )
			{
				throw new Error("ClockManager 单例" );
			}
		}
		/**
		 * 获取开服天数 
		 * @return 
		 * 
		 */		
		public function get serverOpenDateNum():int
		{
			return _serverOpenDateNum;
		}

		public function set serverOpenDate(value:Number):void
		{
			_serverOpenDate = value;
			var sd:Date = new Date(_serverOpenDate*1000);
			sd = new Date(sd.fullYear,sd.month,sd.date);
			_serverOpenDateNum = Math.ceil( (nowDate.time-sd.time)/(1000*3600*24) );
			serverOpenDayChange();
		}

		public function set roleCreateDate(value:Date):void
		{
			_roleCreateDate = value;
		}

		public static function get instance():ClockManager
		{
			if( _instance == null )
			{
				_instance = new ClockManager();
			}
			return _instance;
		}
		
		private function initGameClock():void
		{
			_gameClock = new GameClock();
			_gameClock.enterFrameHandler = enterFrameHandler;
			_gameClock.x = 100;
			_gameClock.y = 90;
		}
		
		public function addToStage():void
		{
			if(!_gameClock)
			{
				initGameClock();
			}
			
			if( _gameClock.parent == null )
			{
				Global.stage.addChild(_gameClock);
			}
		}
		
		private function enterFrameHandler( date:Date ):void
		{
			if( _serverDate.date < date.date 
				|| _serverDate.month <date.month 
				|| _serverDate.fullYear < date.fullYear )
			{
				_serverDate.time = date.time;
				dispatchEvent(new TimeEvent( TimeEvent.DateChange ));
				_serverOpenDateNum ++;
				serverOpenDayChange();
			}
			var tdate:Date;
			for( var td:Object in _timeMap )
			{
				tdate = td as Date;
				if( tdate)
				{
					if( tdate.time <= date.time)
					{
						_timeMap[tdate]();
						
						removeDateCall(tdate);
					}
				}
			}
		}
		
		/**
		 * 添加一个时间点 执行函数 执行此函数的判断标准是：小于等于当前时间点秒数值
		 * @param date
		 * @param callback
		 * 
		 */		
		public function addDateCall( date:Date , callback:Function ):void
		{
			if( callback is Function )
			{
				if( date.time > _gameClock.nowDate.time )
				{
					_timeMap[ date ] = callback;
				}
			}
		}
		
		/**
		 * 删除已个时间点 
		 * @param date
		 * 
		 */		
		public function removeDateCall(date:Date):void
		{
			if( _timeMap[ date ] )
			{
				_timeMap[ date ] = null;
				delete _timeMap[ date ];
			}
		}
		
		/**
		 * 开服天数 
		 * @return 
		 * 
		 */		
		private function serverOpenDayChange():void
		{
			dispatchEvent(new TimeEvent( TimeEvent.ServerOpenDayChange ));
		}
		
		/**
		 * 设置现在的时间 
		 * @param time
		 * 
		 */		
		public function setNowTimer( time:Object ):void
		{
			if( _gameClock==null )
			{
				_gameClock = new GameClock();
				_gameClock.enterFrameHandler = enterFrameHandler;
				_gameClock.x = 100;
				_gameClock.y = 90;
			}
			_gameClock.time = time;
			
			_serverDate = new Date( _gameClock.nowDate.time );
		}
		
		/**
		 * 获取现在的时间 
		 * @return 
		 * 
		 */		
		public function get nowDate():Date
		{
			if(!_gameClock)
			{
				initGameClock();
			}
			return _gameClock.nowDate;
		}
		
		/**
		 * 获取现在的延迟多少毫秒的下一个时间点 
		 * @return 
		 * 
		 */		
		public function getDelayDate(delay:Number):Date
		{
			var time:Number = nowDate.time + delay;
			return new Date(time);
		}
		
		/**
		 * 获取第几天登陆 
		 * @return 
		 * 
		 */		
		public function getLoginDayNum():int
		{
			if( _roleCreateDate && _gameClock.nowDate)
			{
				var num:Number =  _roleCreateDate.time - _gameClock.nowDate.time;
				return Math.ceil(num/DayTime);
			}
			return 1;
		}
		
		/**
		 * 是否是创号日 
		 * @return 
		 * 
		 */		
		public function isNotCreateRoleDay():Boolean
		{
			if( _roleCreateDate && _gameClock.nowDate)
			{
				return _roleCreateDate.date != _gameClock.nowDate.date || _roleCreateDate.month!=_gameClock.nowDate.month || _roleCreateDate.fullYear!=_gameClock.nowDate.fullYear;
			}
			return false;
		}
		
		/**
		 * 开始到现在运行多久 
		 * @return 
		 * 
		 */		
		public function getRunningTime():Number
		{
			return _gameClock.nowDate.time - _serverDate.time;
		}
		
		public function get serverOpenDate():Number
		{
			return _serverOpenDate;
		}
	}
}
