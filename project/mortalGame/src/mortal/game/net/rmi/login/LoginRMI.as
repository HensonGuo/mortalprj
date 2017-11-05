package mortal.game.net.rmi.login
{
	import Message.Login.ILoginPrx;
	import Message.Login.ILoginPrxHelper;
	import Message.Public.SLoginInfoShow;
	
	import mortal.common.net.RMIBase;
	import mortal.common.net.RMISession;
	import mortal.game.net.LoginMessageHandler;

	public class LoginRMI extends RMIBase
	{
		
		private static var _instance:LoginRMI; 
		
		
		public function LoginRMI()
		{
			if( _instance != null  )
			{
				throw new Error( "CreateRoleRMI 单例" );
			}
			new SLoginInfoShow();
		}
		
		public static function get instance():LoginRMI
		{
			if( _instance == null )
			{
				_instance = new LoginRMI();
			}
			
			return _instance;
		}
		
		override public function set rmiSession(value:RMISession):void
		{
			value.session.messageHandler = new LoginMessageHandler();
			super.rmiSession = value;
		}
		
		public var loginProxy:ILoginPrxHelper = new ILoginPrxHelper();
		
		override protected function initProxy():void
		{
			session.registerProxy(loginProxy);  //登陆接口
		}
	}
}