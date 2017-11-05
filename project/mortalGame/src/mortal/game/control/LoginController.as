package mortal.game.control
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_ILoginGame_loginGame;
	import Message.Game.SLoginGameReturn;
	import Message.Login.SLoginReturn;
	import Message.Login.SMyRole;
	
	import baseEngine.system.Device3D;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.debug.Log;
	import com.gengine.game.MapConfig;
	import com.gengine.global.Global;
	import com.gengine.manager.CacheManager;
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.ChatFraudFilter;
	import com.gengine.utils.FilterText;
	import com.gengine.utils.TimerTest;
	
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import flash.display.DisplayObjectContainer;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mortal.common.ResManager;
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.preLoadPage.GameLoadBar;
	import mortal.common.preLoadPage.PreLoginProxy;
	import mortal.common.shortcutsKey.ShortcutsKey;
	import mortal.game.Game;
	import mortal.game.GameLayout;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.resource.ConstConfig;
	import mortal.game.resource.ModuleConfig;
	import mortal.game.resource.MusicsAndSoundsConfig;
	import mortal.game.resource.ResConfig;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.model.SceneGlobalPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;

	public class LoginController extends Controller
	{
		private static var _instance:LoginController;
		
		public var stage:DisplayObjectContainer; 
		
		private var _sloginGameReturn:SLoginGameReturn;//登陆游戏服务器返回数据
		
		
		public function LoginController()
		{
			if(_instance)
			{
				throw new Error("LoginController 单例！");
			}
		}
		
		public static function get instance():LoginController
		{
			if(!_instance)
			{
				_instance = new LoginController();
			}
			return _instance;
		}
		
		/**
		 * 登陆游戏服务器 
		 * 
		 */		
		
		public function loadGame():void
		{
//			if( PHPSender.isCreateRole )
//			{
//				PHPSender.sendToURLByPHP(SenderType.LoginGame);
//			}
			Log.debug(PreLoginProxy.instance.gameSession.gmaeSession.url,"系统总内存:",System.totalMemory);
			var sloginReturn:SLoginReturn = PreLoginProxy.instance.sloginReturn;
			GameRMI.instance.rmiSession = PreLoginProxy.instance.gameSession.gmaeSession;
			GameRMI.instance.loginGameProxy.loginGame_async(new AMI_ILoginGame_loginGame(loginGameSuccess,loginGameException),sloginReturn.playerId,ParamsConst.instance.username,
							sloginReturn.name,sloginReturn.sessionKey.id,sloginReturn.sessionKey.key,ParamsConst.Version,ParamsConst.instance.currentCity);
			Cache.instance.login.loginData = PreLoginProxy.instance.slogin;
			Cache.instance.login.loginReturn = sloginReturn;
		}
		
		
		/**
		 * 登陆游戏服务器成功 
		 * 
		 */		
		private function loginGameSuccess( obj:Object, sloginGameReturn:SLoginGameReturn ):void
		{
			Log.debug(PreLoginProxy.instance.gameSession.gmaeSession.url,"成功","系统总内存:",System.totalMemory);
			PHPSender.sendGift(sloginGameReturn.player.playerId);
			
			if( PHPSender.isCreateRole )
			{
				var url:String = ParamsConst.instance.gameMsgURL;
				if( url != null && url != "" )
				{
					sendToURL( new URLRequest( url+"&username="+encodeURI(ParamsConst.instance.username)+"&rolename="+ encodeURI(sloginGameReturn.player.name) ) );
				}
				
				PHPSender.sendToURLByPHP(SenderType.LoginGameSuccess);//登陆游戏成功
			}
			
			PHPSender.isCreateRole = false;
			
			ClockManager.instance.roleCreateDate = sloginGameReturn.player.createDt;
			//ClockManager.addToStage();
			ClockManager.instance.setNowTimer(sloginGameReturn.sysDt);
			
			
//			var date:Date = new Date(sloginGameReturn.sysDt.time);
//			date.minutes +=1 
//			ClockManager.instance.addDateCall(date,function():void{ Alert.show("时间到"); });
			
			_sloginGameReturn = sloginGameReturn;
			
			Cache.instance.login.loginGame = sloginGameReturn;
			
			_mapID = _sloginGameReturn.pos.map;
			_currentGridX = _sloginGameReturn.pos.x;
			_currentGridY = _sloginGameReturn.pos.y;
			
//			_mapID = 100101;
//			_currentGridX = 40;
//			_currentGridY = 40;
//			_proxyID = _sloginGameReturn.pos.proxyId;
//			_serverID = _sloginGameReturn.pos.serverId;
			
			initApp();
			
			GameManager.instance.init(); //游戏初始化 比如键盘监听开始
			ShortcutsKey.instance;
			
			if( ClockManager.instance.isNotCreateRoleDay() )
			{
				if( CacheManager.instance.isCache == false )
				{
					if( Global.isDebugModle == false )
					{
						//显示缓存窗口
					}
				}
			}
			
			ResManager.instance.loadLevelRes();
			
			Dispatcher.dispatchEvent( new DataEvent(EventName.LoginGameSuccess ) );
			
			if( ParamsConst.instance.timerTestType > 0 )
			{
				setTimeout(startTimerTest,1000*10);
				Log.debug("TimerTest start:"+ParamsConst.instance.timerTestType);
			}
		}
		
		
		private function startTimerTest():void
		{
			var test:TimerTest = new TimerTest( Global.stage );
			TimerTest.Delay = ParamsConst.instance.timerTestType;
			test.start();
		}
		
		/**
		 * 初始化程序
		 * 
		 * 初始化地图
		 * 初始化界面
		 * 
		 * 
		 */		
		private function initApp():void
		{
			initConfig();
			
			if(GameLoadBar.instance)
			{
				GameLoadBar.instance.hide();
			}
			
			initUI();
			
			initModules();
			
			initMap();
		}
		private function initConfig():void
		{
			// 初始化配置文件
			//trace("ddddddddd---" + getTimer());
			ResConfig.instance;
			//trace("ddddddddd---" + getTimer());
			ConstConfig.instance;
			
			Log.system("准备初始化屏蔽字","系统总内存:",System.totalMemory,"时间：",getTimer());
			FilterText.instance.setFilterStr(ConfigManager.instance.getStringByFileName("filterChat.txt"));
			Log.system("初始化屏蔽字完成","系统总内存:",System.totalMemory,"时间：",getTimer());
//			
//			//过滤聊天卖YB 打广告
//			var obj:Object =  ConfigManager.instance.getObjectByFileName("ChatFraudFilter.xml");
//			if( obj.filter )
//			{
//				if(obj.filter is Array )
//				{
//					ChatFraudFilter.source = obj.filter as Array;
//				}
//				else
//				{
//					ChatFraudFilter.source = [obj.filter];
//				}
//			}
//			NPCConfig.instance.init();
			
//			MusicsAndSoundsConfig.instance;
		}
		/**
		 * 初始化主界面UI 
		 * 
		 */		
		private function initUI():void
		{
			Log.system("准备初始化UI","系统总内存:",System.totalMemory);
			GameController.chat.view.show();
			GameController.navbar.view.show();
			GameController.rightTopBar.view.show();
//			GameController.smallMap.view.show();
			GameController.shortcut.view.show();
			GameController.mapNavBar.view.show();
			GameController.avatar.view.show();
			GameController.selectAvatar.view.show();
			GameController.team.view.show();
			GameController.task.view.show();
			MsgManager.addSpeakerStage(LayerManager.uiLayer);
			GameLayout.instance.init();  //布局初始化
			Log.system("初始化UI","系统总内存:",System.totalMemory);
		}
		
		/**
		 * 初始化模块数据 
		 * 
		 */	
		private function initModules():void
		{
			ModuleConfig.instance.init();
		}
		
		/**
		 * 加载地图 
		 * 
		 */
		private var _mapID:int = 100101;
		private var _currentGridX:int = 200;
		private var _currentGridY:int = 200;
		private var _proxyID:int = 0;
		private var _serverID:int = 0;
		
		private function initMap():void
		{
			MapConfig.mapPath = PathConst.mapPath;
			
			MapConfig.modelPath = PathConst.modelPath;
			
			Game.scene = new GameScene3D( Global.application );
			SceneGlobalPlayer.initGlobalPlayers();//初始化全局特效
			Device3D.scene = Game.scene;
			Game.scene.start();
			
			GameController.scene.view;
			
			MapFileUtil.mapID = _mapID;
			MapFileUtil.proxyID = _proxyID;
			MapFileUtil.serverID = _serverID;
			GameMapUtil.curMapState.initMapId(_mapID);//,_proxyID,_serverID);
			Game.scene.setPlayerPoint(_mapID,_currentGridX,_currentGridY);
			
			Dispatcher.dispatchEvent(new DataEvent( EventName.ChangeScene )); 
			
			Log.debug("地图ID:"+_mapID);
			GameLayout.instance.resize( true );
		}
		
		/**
		 * 登陆游戏异常 
		 * 
		 */		
		public function loginGameException(ex:Exception):void
		{
			Log.debug(PreLoginProxy.instance.gameSession.gmaeSession.url,"失败");
			
			MsgManager.alertError(ex.code);
			
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoginGameFail,ex.message);//登陆游戏失败
			}
//			GameLoadBar.instance.hide();
		}
		
		private function onResourceLoaded(e:DataEvent):void
		{
			if(GameLoadBar.instance)
			{
				GameLoadBar.instance.visible = false;
			}
		}
		private function onEnterGame(e:DataEvent):void
		{
			PreLoginProxy.instance.doEnterGame(e.data as SMyRole);
		}
		private function onSetMain(e:DataEvent):void
		{
			PreLoginProxy.instance.doSetMain(e.data as SMyRole);
		}
	}
}