package extend.php
{
	
	import com.gengine.debug.Log;
	import com.gengine.manager.CacheManager;
	
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mortal.common.global.ParamsConst;
	
	public class PHPSender
	{
		private static const FRXZ_SO:String = "frxz2_so";
		private static var _hasSend:Boolean = true;//是否需要发送
		private static var _userNameObject:Object;
		private static var _allUser:Object;
		
		private static var _infoMap:Object = {};
		
		public static var isCreateRole:Boolean = false;
		
		private static var _myShareObject:SharedObject;
		
		public function PHPSender()
		{
			
		}
		
		private static function getShareObject():void
		{
			//判断所有用户数据是否为NULL 如果为NULL 读取sharedObject中数据
			if( _myShareObject == null)
			{
				_myShareObject = CacheManager.instance.getLocal(FRXZ_SO);
				_myShareObject.addEventListener(NetStatusEvent.NET_STATUS,onNetStatusEvent);
			}
		}
		
		private static function onNetStatusEvent(e:NetStatusEvent):void 
		{
//			if (e.info.code == "SharedObject.Flush.Failed") 
//			{
//			}
//			else 
//			{
//			}
		}
		
		/**
		 * 统计界面操作
		 * 1 加载完成
		 * 2 点击页面 
		 * @param type
		 * 
		 */		
		public static function sendToURLByPHP( type:int ,info:String=""):void
		{
			if( isSend( ParamsConst.instance.username,type ) == false ) return;
			try
			{
				if( null != ParamsConst.instance.dothingUrl && ParamsConst.instance.dothingUrl != "")
				{
					var str:String = ParamsConst.instance.dothingUrl+"&do="+type;
					str += "&type="+type+"&username="+encodeURI(ParamsConst.instance.username)+"&phpID="+ParamsConst.instance.phpID;
					if( info != "" )
					{
						str +="&info="+encodeURI(type+"->"+info);
					}
					else
					{
						var typeInfo:String = SenderType.getInfoByType(type);
						str +="&info="+encodeURI(type+"->"+ParamsConst.instance.username+"->"+typeInfo); 
					}
					addQueue( new URLRequest( str ));
				}
			}
			catch(e:Error){
			
				Log.system(e.message);
			}
		}
		
//		private static var _timer:Timer; 
//		private static var _urlList:Array = [];
		private static var _nextTime:Number = 0; //下次可以发送数据的时间
		private static const Max_Time:int = 500;
		private static function addQueue( url:URLRequest ):void
		{
			var time:Number = getTimer();
			var interval:Number =  - _nextTime;
			if( time > _nextTime )
			{
				sendToURL(url);
				_nextTime = time+Max_Time;
			}
			else
			{
				setTimeout(sendToURL,_nextTime-time,url);
				_nextTime = _nextTime + Max_Time;
			}
			
//			_urlList.push(url);
//			if( _timer == null )
//			{
//				_timer = new Timer(1000);
//				_timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
//			}
//			
//			if( _timer.running == false )
//			{
//				_timer.start();
//			}
		}
		
//		private static function onTimerHandler(event:TimerEvent):void
//		{
//			if( _urlList.length > 0 )
//			{
//				var url:URLRequest = _urlList.shift() as URLRequest;
//				if( url )
//				{
//					sendToURL(url);
//				}
//			}
//			else
//			{
//				_timer.stop();
//			}
//		}
	
		
		public static function isSend( username:String,type:int ):Boolean
		{
			getShareObject();
			if( _allUser == null )
			{
				_allUser = _myShareObject.data["userNameObject"];
				if( _allUser == null )
				{
					_allUser = {};
				}
			}
			// 当前用户是否为null 为NULL 就创建对象
			if(_userNameObject == null )
			{
				_userNameObject = _allUser[ParamsConst.instance.loginIP+"_"+username];
				if( _userNameObject == null )
				{
					_userNameObject = {time:ParamsConst.instance.time};
					_allUser[ ParamsConst.instance.loginIP+"_"+username ] = _userNameObject;
				}
			}
			
			//判断有没有用户有没有这个类型
			if( _userNameObject[type] )
			{
				return false;
			}
			else
			{
				_userNameObject[type] = true;
			}
			
			_myShareObject.data.userNameObject = _allUser;
			_myShareObject.flush(10000);
			return true;
		}
		
		/**
		 * 玩家登陆进游戏后调用的登录奖励发放接口

		 * @return 
		 * 
		 */		
		public static function sendGift( playerid:int ):void
		{
			if(ParamsConst.instance.loginGiftUrl != null && ParamsConst.instance.loginGiftUrl != "")
			{
				sendToURL( new URLRequest( ParamsConst.instance.loginGiftUrl+"&playerid="+playerid ));
			}
		}
		
		public static function clearUserName( userName:String ):void
		{
			getShareObject();
			
			if( _allUser == null )
			{
				_allUser = _myShareObject.data["userNameObject"];
			}
			if( _allUser )
			{
				var userObject:Object = _allUser[ParamsConst.instance.loginIP+"_"+userName];
				if( userObject )
				{
					var date:Date = userObject.time as Date;
					var nowDate:Date = ParamsConst.instance.time as Date;
					if( date.date != nowDate.date )
					{
						delete _allUser[ParamsConst.instance.loginIP+"_"+userName];
						_myShareObject.data.userNameObject = _allUser;
						_myShareObject.flush(10000);
					}
				}
			}
		}
		
		/**
		 * 人人网关注接口 
		 * 
		 */
		public static function renrenAttention():void
		{
			if(ParamsConst.instance.attentionUrl != null && ParamsConst.instance.attentionUrl != "")
			{
				sendToURL( new URLRequest( ParamsConst.instance.attentionUrl ));
			}
		}
	}
}