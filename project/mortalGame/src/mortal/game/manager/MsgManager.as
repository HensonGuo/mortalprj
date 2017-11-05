/**
 * @date	2011-3-16 下午09:44:38
 * @author  jianglang
 * 
 */	

package mortal.game.manager
{
	import Framework.Util.Exception;
	
	import Message.DB.Tables.TErrorCode;
	import Message.Public.EShowArea;
	import Message.Public.SErrorMsg;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.mui.controls.Alert;
	
	import flash.display.DisplayObjectContainer;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.manager.msgTip.MsgBroadCastImpl;
	import mortal.game.manager.msgTip.MsgCopyTaskEndImpl;
	import mortal.game.manager.msgTip.MsgFloatWordImpl;
	import mortal.game.manager.msgTip.MsgGuideTipsImpl;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.manager.msgTip.MsgPlotShowImpl;
	import mortal.game.manager.msgTip.MsgRollRadioImpl;
	import mortal.game.manager.msgTip.MsgRollTipsImpl;
	import mortal.game.manager.msgTip.MsgSceneInfoImpl;
	import mortal.game.manager.msgTip.MsgSpeakerImpl;
	import mortal.game.manager.msgTip.MsgTaskShowImpl;
	import mortal.game.manager.msgTip.MsgTipTextImpl;
	import mortal.game.manager.msgTip.MsgType;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ErrorCodeConfig;
	import mortal.game.view.chat.ChatModule;
	import mortal.game.view.chat.chatPanel.HistoryMsg;
	import mortal.mvc.interfaces.ILayer;

	public class MsgManager
	{
		private static var _msgBroadImpl:MsgBroadCastImpl;
		private static var _msgTipImpl:MsgTipTextImpl ;
		private static var _msgSpeakerImpl:MsgSpeakerImpl = new MsgSpeakerImpl();
		private static var _msgFloatWordImpl:MsgFloatWordImpl
		private static var _msgTaskShowImpl:MsgTaskShowImpl
		private static var _msgCopyTaskEndImpl:MsgCopyTaskEndImpl
		private static var _msgRollRadioImpl:MsgRollRadioImpl 
		private static var _msgRollTipsImpl:MsgRollTipsImpl
		private static var _msgGuideTipsImpl:MsgGuideTipsImpl 
		private static var _msgSceneInfo:MsgSceneInfoImpl
		private static var _msgPlotInfo:MsgPlotShowImpl
		
		public function MsgManager()
		{
			
		}
		
		private static function get msgBroadImpl():MsgBroadCastImpl
		{
			return _msgBroadImpl || (_msgBroadImpl=new MsgBroadCastImpl())
		}
		private static function get msgTipImpl():MsgTipTextImpl
		{
			return _msgTipImpl || (_msgTipImpl=new MsgTipTextImpl())
		}
		private static function get msgFloatWordImpl():MsgFloatWordImpl
		{
			return _msgFloatWordImpl || (_msgFloatWordImpl=new MsgFloatWordImpl())
		}
		private static function get msgTaskShowImpl():MsgTaskShowImpl
		{
			return _msgTaskShowImpl || (_msgTaskShowImpl=new MsgTaskShowImpl())
		}
		private static function get msgCopyTaskEndImpl():MsgCopyTaskEndImpl
		{
			return _msgCopyTaskEndImpl || (_msgCopyTaskEndImpl=new MsgCopyTaskEndImpl())
		}
		private static function get msgRollRadioImpl():MsgRollRadioImpl
		{
			return _msgRollRadioImpl || (_msgRollRadioImpl=new MsgRollRadioImpl())
		}
		private static function get msgRollTipsImpl():MsgRollTipsImpl
		{
			return _msgRollTipsImpl || (_msgRollTipsImpl=new MsgRollTipsImpl())
		}
		private static function get msgGuideTipsImpl():MsgGuideTipsImpl
		{
			return _msgGuideTipsImpl || (_msgGuideTipsImpl=new MsgGuideTipsImpl())
		}
		private static function get msgSceneInfo():MsgSceneInfoImpl
		{
			return _msgSceneInfo || (_msgSceneInfo=new MsgSceneInfoImpl())
		}
		private static function get msgPlotInfo():MsgPlotShowImpl
		{
			return _msgPlotInfo || (_msgPlotInfo=new MsgPlotShowImpl())
		}
		/**
		 * 添加广播到父容器 
		 * @param parent
		 * 
		 */
		public static function addBroadStage(parent:ILayer):void
		{
			msgBroadImpl.layer = parent;
		}
		
		/**
		 * 添加历史记录到父容器 
		 * @param parent
		 * 
		 */
		public static function addTipStage(parent:DisplayObjectContainer):void
		{
			parent.addChild(msgTipImpl);
		}
		
		/**
		 * 添加大喇叭到父容器 
		 * @param parent
		 * 
		 */
		public static function addSpeakerStage(parent:DisplayObjectContainer):void
		{
			parent.addChild(_msgSpeakerImpl);
		}
		
		/**
		 * 舞台改变大小 
		 * 
		 */
		public static function resize():void
		{
			msgBroadImpl.stageResize();
			msgTipImpl.stageResize();
			_msgSpeakerImpl.setPxy();
			msgFloatWordImpl.stageResize();
			msgTaskShowImpl.stageResize();
			msgCopyTaskEndImpl.stageResize();
			msgRollRadioImpl.stageResize();
			msgRollTipsImpl.stageResize();
			msgSceneInfo.stageReseze();
			msgPlotInfo.stageReseze();
		}
		
		/**
		 * 聊天高度改变
		 */
		public static function chatResize():void
		{
			_msgSpeakerImpl.setPxy();
		}
		
		/**
		 * 添加一条广播消息 
		 * @param data
		 * @param type
		 * 
		 */
		public static function addBroadCast( data:Object , type:MsgTypeImpl = null ):void
		{
			if( data == null ) return;
			type = type==null?MsgType.DefaultMsg:type;
			msgBroadImpl.showNotice(data.toString());
		}
		
		/**
		 * 添加一条历史记录 
		 * @param data
		 * @param type 参考枚举MsgHistoryType
		 * 
		 */
		public static function addTipText( data:String , msgHistoryType:MsgTypeImpl ):void
		{
			if( data == null ) return;
//			type = type==null?MsgType.DefaultMsg:type;
//			msgTipImpl.showInfo(data.toString(),type.color,type.delay);
			(GameController.chat.view as ChatModule).addSystemMsg(data,msgHistoryType);
		}
		
		/**
		 * 添加一条大喇叭消息 
		 * @param data
		 * @param type
		 * 
		 */
		public static function addSpeakerText( miniPlayer:SMiniPlayer,content:String, type:MsgTypeImpl = null):void
		{
			if( miniPlayer == null ) return;
			type = type==null?MsgType.DefaultMsg:type;
			_msgSpeakerImpl.showSpeakerNotice(miniPlayer,content, type);
		}
		
		/**
		 * 添加一条飘字提示 
		 * @param data
		 * @param type
		 * 
		 */
		public static function addFloatWord(data:Object,type:MsgTypeImpl = null):void
		{
			if( data == null ) return;
			type = type==null?MsgType.DefaultMsg:type;
			msgFloatWordImpl.showWord(data.toString());
		}
		
		/**
		 * 移除飘字提示 
		 * 
		 */
		public static function removeFloatWord():void
		{
			msgFloatWordImpl.dispose();
		}
		
		/**
		 * 添加一条任务目标提示 
		 * @param str 内容
		 * @param daily 显示时间
		 * 
		 */
		public static function showTaskTarget(str:String,daily:int = 5):void
		{
			if(!str)
			{
				return;
			}
			msgTaskShowImpl.showTarget(str,daily);
		}
		
		public static function removeTaskTarget():void
		{
			msgTaskShowImpl.hide();
		}
		
		/**
		 * 添加一条屏幕横线滚动飘字 
		 * @param str 			需要播放的文字
		 * @param totalCount 	需要播放的循环次数
		 * @param totalCount 	需要播放的速度
		 * 
		 */
		public static function showRollRadioMsg(str:String,totalCount:int = 3,speed:int = 2):void
		{
			if(str == null || str == "") 
			{
				return;
			}
			msgRollRadioImpl.showMsg(str,totalCount,speed);
		}
		
		/**
		 * 隐藏屏幕横线滚屏飘字 
		 * 
		 */
		public static function hideRollRadioMsg():void
		{
			msgRollRadioImpl.hide();
		}
		
		/**
		 * 显示竖向滚动飘字 
		 * @param info
		 * 
		 */
		public static function showRollTipsMsg(info:String):void
		{
			if(info == null || info == "")
			{
				return;
			}
			msgRollTipsImpl.showMsg(info);
			msgTipImpl.showInfo(info);
			Log.debug(info);
		}
		
		/**
		 * 显示指引文字 
		 * @param str
		 * @param deley
		 * 
		 */
		public static function showGuideTips(str:String,px:int,py:int,layer:DisplayObjectContainer = null,deley:int=0):void
		{
			msgGuideTipsImpl.show(str,px,py,layer,deley);
		}
		
		/**
		 * 隐藏指引飘字 
		 * 
		 */
		public static function hideGuideTips():void
		{
			msgGuideTipsImpl.hide();
		}
		
		/**
		 * 显示副本任务完成后的信息 
		 * @param str
		 * @param deley
		 * @param count
		 * @param callBack
		 * 
		 */
		public static function showCopyEndStr(str:String,deley:int,count:int,callBack:Function=null):void
		{
			msgCopyTaskEndImpl.show(str,deley,count,callBack);
		}
		
		/**
		 * 隐藏副本任务完成之后的信息 
		 * 
		 */
		public static function hideCopyEndStr():void
		{
			msgCopyTaskEndImpl.hide();
		}
		
		/**
		 * 显示场景描述 
		 * @param sceneName
		 * @param sceneDes
		 * 
		 */
		public static function showSceneDes(sceneName:String,desArray:Array):void
		{
			if(sceneName && desArray && sceneName != "" && desArray.length > 0)
			{
				msgSceneInfo.showMsg(sceneName,desArray);
			}
		}
		
		/**
		 * 隐藏场景描述 
		 * 
		 */
		public static function hideSceneDes():void
		{
			msgSceneInfo.hideMsg();
		}
		
		/**
		 * 场景引导诗句 
		 * @param msgStr
		 * @param endCallBack
		 * 
		 */
		public static function showPlotMsg(msgStr:String,endCallBack:Function = null):void
		{
			msgPlotInfo.showMsg(msgStr,endCallBack);
		}
		
		/**
		 * 隐藏引导诗句 
		 * 
		 */
		public static function hidePlotMsg():void
		{
			msgPlotInfo.hideMsg();
		}
		
		public static function alertError( code:int ):void
		{
			Alert.show("错误码："+code+"  信息："+ ErrorCode.getErrorStringByCode(code),"错误信息"  );
		}
		
		public static function alertIssm( value:String ):void
		{
			
		}
		
		public static function addChatMsg( value:Object ,type:String):void
		{
//			GameController.chat.addTipMsg(value,type);
		}
		
		
		public static function systemError( error:Object ):void
		{
			var code:int;
			var msg:String ="";
			var errorStr:String = "";
			if( error is Exception )
			{
				var exception:Exception = error as Exception;
				code = exception.code;
				msg = exception.message;
				errorStr = "RMI系统错误:"+ exception.method+"，code："+exception.code;
				rmiCallback( exception );
			}
			else if( error is SErrorMsg )
			{
				var errorMsg:SErrorMsg = error as SErrorMsg;
				code = errorMsg.code;
				msg = errorMsg.message;
				errorStr = "cmd错误:,code："+error.code;
				errorCallback( errorMsg );
			}
			
			showErrorByCode(code,errorStr,msg);
		}
		
		/**
		 * 根据错误码显示错误信息 
		 * @param errorCode
		 * @param errorStr
		 * 
		 */
		public static function showErrorByCode(code:int,errorStr:String = "",msg:String = ""):void
		{
			var errorCode:TErrorCode = ErrorCodeConfig.instance.getInfoByCode(code);
			
			if( errorCode )
			{
				if( errorCode.showServerMsg == 1)  //显示服务器错误
				{
					addTips( errorStr,msg ,errorCode.display);
				}
				else
				{
					addTips( errorStr,errorCode.errorStr,errorCode.display);
				}
				
//				//镖车被劫
//				if( code == ErrorCode.ErrorCell_EscortIsAttacked )
//				{
//					Dispatcher.dispatchEvent(new DataEvent( EventName.EscortIsAttacked ));
//					sendErrorMsgCount( errorCode.errorStr , 20 );
//				}
			}
			else
			{
				addTips( errorStr,ErrorCode.getErrorStringByCode(code),0);
			}
			
//			if(code == ErrorCode.ErrorCell_ObstructNotFight)//地形阻挡不可以攻击
//			{
//				RolePlayer.instance.obstructNotFight();
//			}
//			else if(code ==  ErrorCode.ErrorCell_CollectHasOwner)//目标正在采集中
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.CollectHasOwner));
//			}
//			else if(code == ErrorCode.ErrorCell_FightToEntityNotOnline)//目标不存在
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.FightEntityNotOnLine));
//			}
//			else if(code == ErrorCode.ErroeCell_CollectToEntityNotOnline)//采集目标不存在
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ColloectTargetNotOnLine));
//			}
//			else if(code == ErrorCode.ErrorCell_FightTooFar || code == ErrorCode.ErrorCell_SkillTooFar)//距离太远不可攻击
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.FightTargetIsTooFar));
//			}
//			else if(code == ErrorCode.ErrorCell_CollectDistanceTooFar)//距离太远不可采集
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.CollectTargetIsTooFar));
//			}
//			else if(code == ErrorCode.ErrorCell_InputPointError)//输入坐标错误
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.InputPointError));
//			}
//			else if(code == ErrorCode.ErrorGate_BagBagIsFull || code == ErrorCode.ErrorGate_BagSlotNotEnough)//输入坐标错误
//			{
//				NetDispatcher.dispatchCmd(ServerCommand.BackPackFullCommand,null);
//			}
		}
		
		private static function sendErrorMsgCount( value:String , num:int ):void
		{
			var timer:SecTimer = new SecTimer(1,num);
			timer.addListener(TimerType.ENTERFRAME,onEnterFrameHandler);
			
			function onEnterFrameHandler( timer:SecTimer ):void
			{
				MsgManager.addBroadCast(value);
			}
			timer.start();
		}
		
		/**
		 * /*******************
     	 * 显示区域
      
	      enum EShowArea
	      {
	      	EShowAreaChat = 1,			//聊天区
	      	EShowAreaMiddle = 2,		//屏幕中央
	      	EShowAreaMiddleTop = 4,		//屏幕中央顶层
	      	EShowAreaHistory = 8,		//历史记录区（右下角）
	      	EShowAreaTrumpet = 16,		//大喇叭区
	      }; 
		 * @param errorStr
		 * @param msg
		 * @param display
		 * 
		 */		
		private static function addTips( errorStr:String , msg:String ,display:int):void
		{
			if( Global.isDebugModle )
			{
				errorStr = errorStr+"，错误信息："+msg;
			}
			else
			{
				if( display == 0 )
				{
					return;
				}
				errorStr = msg;
			}
			//显示在聊天
			if( display & EShowArea._EShowAreaChat )
			{
//				MsgManager.addChatMsg(errorStr,ChatType.Tips);
			}
			//显示在历史记录
			if( display & EShowArea._EShowAreaHistory )
			{
				MsgManager.addTipText(errorStr,MsgHistoryType.FightMsg);
			}
			//屏幕中央
			if( display & EShowArea._EShowAreaMiddle )
			{
				MsgManager.addBroadCast(errorStr);
			}
			if( display & EShowArea._EShowAreaRightDown )
			{
				MsgManager.showRollTipsMsg(errorStr);
			}
		}
		
		/**
		 * 命令异常处理 
		 * @param msg
		 * 
		 */		
		private static function errorCallback( msg:SErrorMsg ):void
		{
//			switch(msg.code)
//			{
//				case ErrorCode.ErrorPublic_CopyGroupNotExsit://队伍不存在，请刷新队伍列表
//				{
//					NetDispatcher.dispatchCmd(ServerCommand.Copy_GroupNoExist,null);
//					break;
//				}
//				case ErrorCode.ErrorPublic_CannotGetPetCpnReward://不能领取宠物争霸累积奖励
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetCpnOpenWindow));
//					break;
//				}
//			}
		}
		
		/**
		 * 回调返回异常处理 
		 * @param msg
		 * 
		 */		
		private static function rmiCallback( ex:Exception ):void
		{
			switch(ex.code)
			{
				case ErrorCode.ErrorGate_TransportHadTask:	//执行灵兽护送或护送任务中
				{
					
					break;
				}
			}
		}
		
		/**
		 * 等待飘的字 
		 * @return 
		 * 
		 */
		public static function get rollMsgLength():int
		{
			return msgRollTipsImpl.msgLength;
		}
	}
}
