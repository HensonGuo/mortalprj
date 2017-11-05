package extend.php
{
	public class SenderType
	{
		/**
		 *5:"预加载成功"
			6:"登陆验证服务器"
			
				7:"需要创建角色"
				8：开始加载创号页面
				9：创号页面加载成功
				10：创号页面加载失败
				11：点击创建角色界面
				12：创建角色成功
				13：创建角色失败
			
			14：登陆验证服务器成功
			15：登陆验证服失败
			
				16:加载MainGame.swf成功
				17:加载MainGame.swf失败
				18:"加载配置文件成功",
				19:"加载配置文件失败",
				20:"加载资源文件成功",
				21:"加载资源文件失败",
			
			22:登陆游戏服务器
			23：登陆游戏服务器失败
			24：登陆游戏服务器成功
			25:"服务器连接已断开",
			26:"flash关闭", 
			 * 
			 * 12:"创建角色成功", == 14:"登陆验证服务器成功",
		 */		
		
//		public static const LOAD_CREATEROLE_BEGIN:int = 1;
//		
//		public static const LOAD_CREATEROLE_SUCCESS:int = 2;		
//		public static const LOAD_CREATEROLE_FAIL:int = 14;
//		
//		public static const CLICK_CREATEROLE:int = 3;
//		
//		public static const CREATEROLE_FAIL:int = 4;
//		public static const CREATEROLE_SUCCESS:int = 5;
//		
//		public static const LOGINGAME_SUCCESS:int = 6;
//		public static const LOGINGAME_FAIL:int = 7;
//		
//		public static const LOADMAIN_SUCCESS:int = 8;
//		public static const LOADMAIN_FAIL:int = 9;
//		
//		public static const LOADCONFIG_SUCCESS:int = 10;
//		public static const LOADCONFIG_FAIL:int = 11;
//		
//		public static const LOADRESOURCE_SUCCESS:int = 12;
//		public static const LOADRESOURCE_FAIL:int = 13;
//		
//		public static const GameSocketClose:int = 15;
//		
//		public static const FlashClose:int = 16;
		
		
		
		public static const Preloader:int = 5;
		public static const Login:int = 6;
		
		public static const CreateRole:int = 7;
		
		public static const LoadCreateRole:int = 8;
		
		public static const LoadCreateRoleSuccess:int = 9;
		
		public static const LoadCreateRoleFail:int = 10;
		
		public static const ClickCreateRole:int = 11;
		
		public static const CreateRoleSuccess:int = 12;
		
		public static const CreateRoleFail:int = 13;
		
		public static const LoginSuccess:int = 14;
		
		public static const LoginFail:int = 15;
		
		public static const LoadMaigGameSwfSuccess:int = 16;
		public static const LoadMaigGameSwfFail:int = 17;
		
		public static const LoadConfigSuccess:int = 18;
		public static const LoadConfigFail:int = 19;
		
		public static const LoadResourceSuccess:int = 20;
		public static const LoadResourceFail:int = 21;
		
		
		public static const LoginGame:int = 22;
		
		public static const LoginGameFail:int = 23;
		public static const LoginGameSuccess:int = 24;
		
		public static const GameSocketClose:int = 25;
		public static const FlashClose:int = 26;
		
		private static var _typeInfoMap:Object = {
			5:"预加载成功",
			6:"登陆验证服务器",
			
			7:"需要创建角色",
			8:"开始加载创号页面",
			9:"创号页面加载成功",
			10:"创号页面加载失败",
			11:"点击创建角色界面",
			12:"创建角色成功",
			13:"创建角色失败",
			
			14:"登陆验证服务器成功",
			15:"登陆验证服失败",
			
			16:"加载MainGame.swf成功",
			17:"加载MainGame.swf失败",
			18:"加载配置文件成功",
			19:"加载配置文件失败",
			20:"加载资源文件成功",
			21:"加载资源文件失败",
			
			22:"登陆游戏服务器",
			23:"登陆游戏服务器失败",
			24:"登陆游戏服务器成功",
			25:"服务器连接已断开",
			26:"flash关闭"
		};
		
		public static function getInfoByType( type:int ):String
		{
			return _typeInfoMap[ type ];
		}
		
		public function SenderType()
		{
		}

	}
}