/**
 * @date	2011-4-13 下午12:39:40
 * @author  cjx
 * 
 */	

package mortal.common.preLoadPage
{
	import Framework.MQ.MessageBlock;
	import Framework.Util.Exception;
	
	import Message.Command.EPublicCommand;
	import Message.Login.AMI_ILogin_createFirstRole;
	import Message.Login.AMI_ILogin_login;
	import Message.Login.SFirstRole;
	import Message.Login.SLogin;
	import Message.Login.SLoginReturn;
	import Message.Login.SMyRole;
	import Message.Public.ECamp;
	import Message.Public.ECareer;
	import Message.Public.SLoginInfoShow;
	import Message.Public.SUrl;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.loader.DataLoader;
	
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	import mortal.common.error.ErrorCode;
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.game.net.rmi.login.GameSession;
	import mortal.game.net.rmi.login.LoginRMI;
	import mortal.mvc.core.NetDispatcher;

	public class PreLoginProxy extends EventDispatcher
	{
		private static var _instance:PreLoginProxy;
		
		public static const LOGIN_SUCCESS:String = "loginSuccess";
		
		public var rootStage:Stage;
		
		private var _gameSession:GameSession;
		private var _slogin:SLogin; //登陆数据
		
		public var sloginReturn:SLoginReturn; // 登陆验证返回数据
		
		private var _createRole:MovieClip; //创建角色模块对象

		public function PreLoginProxy()
		{
			if(_instance)
			{
				throw new Error("单例！");
			}
			ErrorCode.init();
		}
		
		public static function get instance():PreLoginProxy
		{
			if(!_instance)
			{
				_instance = new PreLoginProxy();
			}
			return _instance;
		}
		
		/**
		 * 登陆验证服务器
		 * 
		 */		
		
		public function login():void
		{
				_gameSession = new GameSession();
				_gameSession.loginSession.url = ParamsConst.instance.loginIP; 
				LoginRMI.instance.rmiSession = _gameSession.loginSession;
				
				Log.debug("登陆服务器："+_gameSession.loginSession.url);
				
				_slogin = new SLogin();
				
				
//				if( ParamsConst.instance.guest == 1 )
//				{
//					_slogin.username = ParamsConst.instance.username;
//					_slogin.password = ParamsConst.DefaultPassWord;
//					_slogin.loginIp = ParamsConst.instance.loginIP;
//					_slogin.gateIp = ParamsConst.instance.gameIP;
//					_slogin.time = ParamsConst.instance.time as Date;
//				}
//				else
//				{
					_slogin.username = ParamsConst.instance.username;
					
					_slogin.userId = ParamsConst.instance.userId;
					
					_slogin.server =  ParamsConst.instance.server;
					
					_slogin.time = ParamsConst.instance.time as Date;
					
					_slogin.flag = ParamsConst.instance.flag;
					
					_slogin.country = ParamsConst.instance.defaultCamp;
					
					_slogin.isAdult = ParamsConst.instance.isAdult;
					
//					_slogin.version = 0;
					
					_slogin.codeVersion = ParamsConst.Version;
					
					_slogin.platformCode = ParamsConst.instance.platformCode;
					
					_slogin.password = ParamsConst.instance.password;
					
					_slogin.loginIp = ParamsConst.instance.loginIP;
					
					_slogin.totalOnlineTime = ParamsConst.instance.totalOnlineTime;
					
					_slogin.platformUserName = ParamsConst.instance.platformUserName;
					
					_slogin.issm = ParamsConst.instance.issm;
					
//					_slogin.playerId = ParamsConst.instance.player_id;
					
					_slogin.gateIp = ParamsConst.instance.gameIP;
//				}
				
				//Cache.instance.login.loginData = _slogin;
				
				NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicLoginInfoShow, onShowLoginInfo);
				if( PHPSender.isCreateRole )
				{
					PHPSender.sendToURLByPHP(SenderType.Login);
				}
				LoginRMI.instance.loginProxy.login_async(new AMI_ILogin_login(loginSuccess,loginException),_slogin);
		}
		 
		/**
		 * 验证登陆成功
		 * 
		 */		
		public var isLoginSuccess:Boolean = false; //是否已创号
		public function loginSuccess(object:Object,sReturn:SLoginReturn,myRoles:Array=null):void
		{
			if(myRoles && myRoles.length > 0)
			{
				PreloaderCache.isMultipleRole = true;
				PreloaderCache.myRoles = myRoles;
				initApp();
			}
			else
			{
				if(_gameSession.loginSession && _gameSession.loginSession.session)
				{
					_gameSession.loginSession.session.abandon();
				}
				_gameSession.gmaeSession.url = SUrl(sReturn.urls[0]).url;
				//GameRMI.instance.rmiSession =  _gameSession.gmaeSession;
				Log.debug("登陆游戏服务器："+_gameSession.gmaeSession.url);
				sloginReturn = sReturn;
				//Cache.instance.login.loginReturn = sloginReturn;
				
				removeCreateRole();
				
				//若加载页面存在且不可见，则显示
				if(GameLoadBar.instance && !GameLoadBar.instance.visible)// && !GameLoadBar.instance.isGameLoadComplete)
				{
					GameLoadBar.instance.visible = true;
				}
				
				if( PHPSender.isCreateRole )
				{
					PHPSender.sendToURLByPHP(SenderType.CreateRoleSuccess);//创建帐号成功
				}
				PHPSender.renrenAttention();
				isLoginSuccess = true;
				dispatchEvent( new Event(LOGIN_SUCCESS) );
				if(!PreloaderCache.isMultipleRole)
				{
					initApp();
				}
			}
		}
		
		public function createRoleException(ex:Exception):void
		{
			var errorStr:String = ErrorCode.getErrorByLogin(ex.code);
			if( _createRole && _createRole.parent )
			{
				_createRole.showException( errorStr, ex.code );
			}
			else
			{
				if(!isLoginSuccess)
				{
					showErrorInfo(ex);
				}
			}
			
			PHPSender.sendToURLByPHP(SenderType.CreateRoleFail,ex.message);//创建帐号失败
		}
		
		/**
		 * 登陆验证异常 
		 * 比如 没有创建角色 等 
		 * 
		 */		
		public function loginException(ex:Exception):void
		{
			if( ex.code == ErrorCode.ErrorLogin_NoRole )
			{
				PHPSender.isCreateRole = true;
//				if( ParamsConst.instance.guest == 1 )
//				{
//					var obj:Object = {};
//					obj.camp =  ParamsConst.instance.defaultCamp;
//					obj.sex = ParamsConst.instance.defaultSex;
//					obj.name = ParamsConst.instance.roleName;
//					sendCreateRole(obj);
//				}
//				else
//				{
					createRole();
//				}
//				PHPSender.sendToURLByPHP(SenderType.CreateRole);//创建角色
			}
			else
			{
				if(!isLoginSuccess)
				{
					showErrorInfo(ex);
				}
				
				if( PHPSender.isCreateRole )
				{
					PHPSender.sendToURLByPHP(SenderType.LoginFail,"错误码：" + ex.code + "\n错误信息：" + ex.message);//登陆游戏失败
				}
			}
		}
		
		public function createRole( ):void
		{
			var swfloader:Loader = new Loader();
			swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onRoleCompleteHandler);
			swfloader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onRoleProgressHandler);
			swfloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadRoleHandler);
			swfloader.load( new URLRequest(PathConst.createRoleUrl));
			
			PHPSender.sendToURLByPHP(SenderType.LoadCreateRole);//开始加载创建角色界面
		}
		
		private function onRoleCompleteHandler( event:Event ):void
		{
			if(GameLoadBar.instance && GameLoadBar.instance.visible)
			{
				GameLoadBar.instance.visible = false;
			}
			
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE,onRoleCompleteHandler);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onRoleProgressHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadRoleHandler);
			
			_createRole = loaderInfo.content as MovieClip;
			_createRole.mainPath = ParamsConst.instance.mainPath;
			_createRole.version = ParamsConst.Version;
			_createRole.randomNameUrl = ParamsConst.instance.randomNameUrl;
			
			if(_createRole.hasOwnProperty("isAutoEnterGame"))
			{
				_createRole.isAutoEnterGame = ParamsConst.instance.isAutoEnterGame;
			}
			
			rootStage.addChild(_createRole);
//			_createRole.setDefaultParams(ParamsConst.instance.roleName,ParamsConst.instance.defaultSex,ParamsConst.instance.defaultCamp);
			_createRole.setDefaultParams(ParamsConst.instance.roleName,ParamsConst.instance.defaultSex,ECamp._ECampA);
			
			_createRole.submitFun = submitFun;
			if(_createRole.hasOwnProperty("whoPlayGame"))
			{
				_createRole.whoPlayGame(ParamsConst.instance.friendPlayGameUrl,ParamsConst.instance.whoPlayGameUrl);
			}
			rootStage.addEventListener(MouseEvent.CLICK, onCreateRoleClickHandler);
			
			PHPSender.sendToURLByPHP(SenderType.LoadCreateRoleSuccess);//加载创建角色界面成功
			
			initApp();
		}
		
		private function onLoadRoleHandler(event:ErrorEvent):void
		{
			PHPSender.sendToURLByPHP(SenderType.LoadCreateRoleFail,event.text);//加载创建角色界面失败
		}
		
		private function onCreateRoleClickHandler(e:MouseEvent):void
		{
			PHPSender.sendToURLByPHP(SenderType.ClickCreateRole);//点击创建角色界面
			rootStage.removeEventListener(MouseEvent.CLICK, onCreateRoleClickHandler);
		}
		
		/**
		 *显示登陆消息 
		 */
		public function onShowLoginInfo(mb:MessageBlock):void
		{
			var showInfo:SLoginInfoShow = mb.messageBase as SLoginInfoShow;
			if(_createRole && _createRole.parent)
			{
				Object(_createRole).addShowInfo(showInfo.camp, showInfo.sex, showInfo.name);
			}
		}
		
		private function removeCreateRole():void
		{
			if( _createRole &&  _createRole.parent )
			{
				_createRole.parent.removeChild(_createRole);
				_createRole.stopBackgroundMusic();
				_createRole = null;
			}
		}
		
		//设置加载页面进度
		private function onRoleProgressHandler(e:ProgressEvent):void
		{
			GameLoadBar.instance.setProgress(PreloaderConfig.LOAD_CREATE_ROLE,e.bytesLoaded,e.bytesTotal);
		}
		
		private function submitFun( object:Object ):void
		{
			sendCreateRole(object);
		}
		
		private function sendCreateRole(object:Object):void
		{
			var role:SFirstRole = new SFirstRole();
//			role.sex = object.sex;
//			role.name = object.name;
//			role.camp = object.camp;
			role.career = ECareer._ECareerNo;
			
			role.sex = object.sex;
			role.name = object.name;
			role.camp = ECamp._ECampA;
			role.career = object.career;
			
			role.server = ParamsConst.instance.server;
			role.platformCode = ParamsConst.instance.platformCode;
			LoginRMI.instance.loginProxy.createFirstRole_async(new AMI_ILogin_createFirstRole(loginSuccess,createRoleException),role);
		}

		public function get gameSession():GameSession
		{
			return _gameSession;
		}

		public function set gameSession(value:GameSession):void
		{
			_gameSession = value;
		}

		public function get slogin():SLogin
		{
			return _slogin;
		}

		public function set slogin(value:SLogin):void
		{
			_slogin = value;
		}
		
		private var urlloader:URLLoader = new URLLoader();
		private var baseLoader:DataLoader = new DataLoader();
		private var _isLoadedApp:Boolean = false;
		private function initApp():void
		{
			if( _isLoadedApp == false )
			{
				_isLoadedApp = true;
//				urlloader.dataFormat = URLLoaderDataFormat.BINARY;
//				
//				var urlreq:URLRequest = new URLRequest( PathConst.gameUrl + "?v=" + ParamsConst.instance.flashVersion );
//				
//				
//				urlloader.addEventListener(Event.COMPLETE,onCompleteHandler);
//				urlloader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
//				urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
//				
//				urlloader.load(urlreq);
				
				baseLoader.maxReloadTimes = 30;
				baseLoader.reloadSec = 8;
				baseLoader.addEventListener(Event.COMPLETE,onCompleteHandler);
				baseLoader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler);
				baseLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
				baseLoader.load(PathConst.gameUrl + "?v=" + ParamsConst.instance.flashVersion,null);
			}
		}
		
		private function onCompleteHandler( event:Event ):void
		{
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoadMaigGameSwfSuccess); //加载主程序成功
			}
			var loader:Loader = new Loader();
			loader.loadBytes(event.target.bytesData as ByteArray);
			loader.mouseEnabled = false;
			rootStage.addChild(loader);
		}
		
		private function onProgressHandler( event:ProgressEvent ):void
		{
			GameLoadBar.instance.setProgress(PreloaderConfig.LOAD_MAIN_GAME,event.bytesLoaded,event.bytesTotal);
		}
		
		private function onIOErrorHandler( event:ErrorEvent ):void
		{
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoadMaigGameSwfFail,event.text); //加载主程序失败
			}
		}
		
		private function showErrorInfo(ex:Exception):void
		{
			if(Global.isDebugModle)
			{
				var text:TextField = new TextField();
				text.autoSize = TextFieldAutoSize.LEFT;
				text.textColor = 0xFFFFFF;
				text.background = true;
				text.backgroundColor = 0x000000;
				text.x = rootStage.stageWidth/2 - 100;
				text.y = rootStage.stageHeight/2 - 40;
				text.text = "错误码：" + ex.code + "\n错误信息：" + ex.message;
				rootStage.addChild(text);
			}
		}
		
		/**
		 * 选择角色进入游戏
		 * @param e
		 * 
		 */		
		public function doEnterGame(role:SMyRole):void
		{
			_slogin.playerId = role.playerId;
			LoginRMI.instance.loginProxy.login_async(new AMI_ILogin_login(loginSuccess,loginException),_slogin);
		}
		/**
		 * 设置主角色并进入游戏
		 * @param e
		 * 
		 */		
		public function doSetMain(role:SMyRole):void
		{
			_slogin.playerId = role.playerId;
			_slogin.setIsMain = 1;
			LoginRMI.instance.loginProxy.login_async(new AMI_ILogin_login(loginSuccess,loginException),_slogin);
		}
	}
}