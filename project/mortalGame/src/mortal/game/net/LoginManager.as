package mortal.game.net
{
	import Message.Game.SLoginGameReturn;
	import Message.Login.SLoginReturn;
	import Message.Public.SUrl;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.net.RMISession;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.net.rmi.login.AMILoginGame;
	
	
	public class LoginManager
	{
		private static var _instance:LoginManager;
		
		private var _loginGameSuccessCallBack:Function
		
		public function LoginManager()
		{
			if( _instance != null )
			{
				throw new Error(" LoginManager 单例  ");
			}
			_instance = this;
		}
		
		public static function get instance():LoginManager
		{
			if( _instance == null )
			{
				_instance = new LoginManager();
			}
			return _instance;
		}
		
		public function loginGame(sReturn:SLoginReturn,callBack:Function):void
		{
			_loginGameSuccessCallBack = callBack;
			var _gameSession:RMISession = new mortal.common.net.RMISession();
			_gameSession.url = SUrl(sReturn.urls[0]).url;
			
			GameRMI.instance.rmiSession = _gameSession;
			//LoginRMI.instance.rmiSession = _gameSession.gmaeSession;
			
			GameRMI.instance.loginGameProxy.loginGate_async(new AMILoginGame(),
				sReturn.playerId,ParamsConst.instance.username,
				sReturn.name,sReturn.sessionKey.id,
				sReturn.sessionKey.key,ParamsConst.instance.version);
		}
		
		
		public function loginGameSuccess( sloginGameReturn:SLoginGameReturn ):void
		{
			if( _loginGameSuccessCallBack is Function )
			{
				_loginGameSuccessCallBack.call(null,sloginGameReturn);
			}
		}
		
	}
}