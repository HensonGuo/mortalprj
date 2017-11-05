/**
 * @date	2011-3-18 下午08:04:46
 * @author  jianglang
 * 
 */	

package mortal.game.control
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.ECmdCoreCommand;
	import Message.Public.EKickOutReason;
	import Message.Public.SAttribute;
	
	import com.gengine.global.Global;
	import com.gengine.manager.BrowerManager;
	import com.gengine.utils.BrowerUtil;
	import com.mui.controls.Alert;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.view.common.KillUserView;
	import mortal.game.view.msgbroad.IssmNoticItem;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	public class SystemController extends Controller
	{
		private var _alert:Sprite;
		private var _killUserView:KillUserView;
//		private var _closeAlert:Sprite;
		
		
		public function SystemController()
		{
			
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ECmdCoreCommand._ECmdCoreKillUser,onKillUserHandler);
			Dispatcher.addEventListener(EventName.SocketClose,onSockCloseHandler);
//			RolePlayer.instance.addEventListener(PlayerEvent.RoleLevelUpdate,onRoleLevelUpdateHandler);
		}
//		private var _levelUp:EffectPlayer;
//		private function onRoleLevelUpdateHandler( event:PlayerEvent ):void
//		{
//			if (_levelUp)
//			{
//				if (LayerManager.highestLayer.contains(_levelUp))
//				{
//					LayerManager.highestLayer.removeChild(_levelUp);
//				}
//				_levelUp.stop();
//			}
//			else
//			{
//				_levelUp=new EffectPlayer();
//				_levelUp.playTotal = 1;
//			}
//			if( LayerManager.highestLayer.contains(_levelUp) == false )
//			{
//				LayerManager.highestLayer.addChild(_levelUp);
//			}
//			_levelUp.move(Global.stage.stageWidth/2,Global.stage.stageHeight/2-160);
//			_levelUp.load(StaticResUrl.Levelup1, ModelType.Effect, null);
//		}
		
		private var _SockCloseTimeOut:uint;
		
		private function onSockCloseHandler(event:DataEvent):void
		{
			if(_SockCloseTimeOut <=0)
			{
				_SockCloseTimeOut = setTimeout(socketClose,12000);
			}
		}
		
		private function socketClose():void
		{
			if( GameRMI.instance.isConnected == false )
			{
				if( _alert == null )
				{
					Alert.timerNO = false;
	//				Alert.timerOut = 120;
	//				Alert.buttonWidth = 80;
					Alert.mode = Alert.Mode_Simple;
					_alert = Alert.show(Language.getString( 10012 ),null,Alert.OK,null,onCloseHandler);//"连接已断开，请按 确定 重新登陆"
				}
			}
			_SockCloseTimeOut = 0;
		}
		
		private function onCloseHandler(e:int):void
		{
			_alert = null;
			if(e == Alert.OK)
			{
				BrowerManager.instance.reload();
			}
		}
		/**
		 *    /*******************
      	* 踢出原因
	      enum EKickOutReason
	      {
	      	EKickOutReasonByCloseGate = 0,     //重启网关服务器
	      	EKickOutReasonByCloseCell = 1,	   //重启重启CELL服务器
	      	EKickOutReasonByCloseGateMgr = 2,	 //重启网关服务器
	      	EKickOutReasonByCloseInterMgr = 4, //共用服务器关闭
	      	EKickOutReasonByCloseDbApp = 5,    //数据库关闭
	      	EKickOutReasonByElseLogin = 6,     //用户重新登录
	      }; 
		 * @param mb
		 * 
		 */		
		private function onKillUserHandler(mb:MessageBlock):void
		{
			var attribute:SAttribute = mb.messageBase as SAttribute;
			var issmNoticeItem:IssmNoticItem;
			switch( attribute.value )
			{
				case EKickOutReason._EKickOutReasonByLockPlayer:
				{
					alert( Language.getString( 10004 ) );//"10004":"你的账号被锁定，请联系GM",
					break;
				}
				case EKickOutReason._EKickOutReasonByGMOperation:
				{
					alert( Language.getString( 10013 ) ); //GM 踢下线
					break;
				}
				case EKickOutReason._EKickOutReasonByErrorVersion:
				{
					alert( Language.getString( 10005 ) );//"版本与服务器版本不一致，请联系GM"
					break;
				}
				case EKickOutReason._EKickOutReasonByCloseGate:
				{
//					alert("重启网关服务器！！");
					showKillView(EKickOutReason._EKickOutReasonByCloseGate);
					break;
				}
				case EKickOutReason._EKickOutReasonByCloseCell:
				{
//					alert("重启CELL服务器！！"); 
					showKillView(EKickOutReason._EKickOutReasonByCloseCell);
					break;
				}
				case EKickOutReason._EKickOutReasonByCloseGateMgr:
				{ 
//					alert("重启网关服务器！！");
					showKillView(EKickOutReason._EKickOutReasonByCloseGateMgr);
					break;
				}
				case EKickOutReason._EKickOutReasonByCloseDbApp:
				{
//					alert("数据库关闭！！");
					showKillView(EKickOutReason._EKickOutReasonByCloseDbApp);
					break;
				}
				case EKickOutReason._EKickOutReasonByElseLogin:
				{
//					alert("你的账号在其他客户端登录！！");
					showKillView(EKickOutReason._EKickOutReasonByElseLogin);
					break;
				}
				case EKickOutReason._EKickOutReasonByDbUpdateFail: 
				{
//					alert("你的账号在其他客户端登录！！");
					showKillView(EKickOutReason._EKickOutReasonByDbUpdateFail);
					break;
				}
				case EKickOutReason._EKickOutReasonByIssmThreeHour:
				{
					var str1:String = Language.getString(10010);
					alert1( str1 );//"您已进入不健康游戏时间，请您暂时离开游戏进行适\r当休息和运动，合理安排您的游戏时间，点击确定退出游戏。");
					issmNoticeItem = new IssmNoticItem();
					issmNoticeItem.updateData( str1 );
//					MsgManager._msgIssmImpl.addItem(issmNoticeItem);
					break;
				}
				case EKickOutReason._EKickOutReasonByIssmOfflineTimeLessFiveHour:
				{
					var str:String = Language.getString(10011);
					alert1( str );//"您的累计下线时间不满5小时，为了保证您\r能正常游戏，请您稍后登陆。");
					issmNoticeItem = new IssmNoticItem();
					issmNoticeItem.updateData( str );
//					MsgManager._msgIssmImpl.addItem(issmNoticeItem);
					
				    break;
				}		
				
			}
			
		}
		
		private function alert1( value:String ,flags:uint = Alert.OK):void
		{
			if(_killUserView != null)
			{
				return;
			}
			if( _alert == null )
			{
				Alert.mode = Alert.Mode_Simple;
				_alert = Alert.show(value,null,flags,Global.stage as Sprite,closeHandler1);
			}
		}
		
		private function closeHandler1( e:int ):void
		{
			_alert = null;
			if(e == Alert.OK)
			{
				if(ParamsConst.instance.proctecUrl != null && ParamsConst.instance.proctecUrl != "")
				{
					BrowerUtil.getUrl(ParamsConst.instance.proctecUrl,"_self");
				}
				else if(ParamsConst.instance.actimUrl != null && ParamsConst.instance.actimUrl != "")
				{
					BrowerManager.instance.getUrl(ParamsConst.instance.actimUrl);
				}
			}
		}
			
		private function alert( value:String ,flags:uint = Alert.OK):void
		{
			if(_killUserView != null)
			{
				return;
			}
			if( _alert == null )
			{
				Alert.mode = Alert.Mode_Simple;
				_alert = Alert.show(value,null,flags,Global.stage as Sprite,closeHandler);
			}
		}
		
		private function closeHandler( e:int ):void
		{
			_alert = null;
			if(e == Alert.OK)
			{
				if(ParamsConst.instance.actimUrl != null && ParamsConst.instance.actimUrl != "")
				{
					BrowerManager.instance.getUrl(ParamsConst.instance.actimUrl);
				}
			}
		}
		
		/**
		 *显示下线提示 
		 * @param type 踢出类型
		 */		
		private function showKillView(type:int):void
		{
			if(_alert != null)
			{
				return;
			}
			if(_killUserView == null)
			{
				_killUserView = new KillUserView();
			}
			_killUserView.updateContentByType(type);
			_killUserView.show();
		}
	}
}
