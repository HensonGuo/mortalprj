package Engine.error
{
	import flash.utils.Dictionary;
	
	public class RMIErrorCode
	{
		
		private static var _map:Dictionary = new Dictionary();
		
		public function RMIErrorCode()
		{
			
		}
		
		public static function isInError( code:int ):Boolean
		{
			return (code in _map);
		}
		
		public static function getErrorByCode(value:int):String
		{
			return _map[value];
		}
		
		public static const ExceptionCodeRMI : int = 20000;          //RMI基础错误
		public static const ExceptionCodeNotSupported : int = 20001; //RMI框架不支持此操作
		public static const ExceptionCodeInvoke : int = 20002;       //RMI框架不支持这种调用
		public static const ExceptionCodeTimeOut : int = 20003;      //系统操作超时
		public static const ExceptionCodeConnectionNotConnect : int = 20004; //不能够连接服务器
		public static const ExceptionCodeConnectionClosed : int = 20005; //服务器连接被关闭
		public static const ExceptionCodeConnectionWrite : int = 20006;  //数据发送失败
		public static const ExceptionCodeObjectNotExist : int = 20007;   //服务对象不存在
		public static const ExceptionCodeOperationNotExist : int = 20008; //服务方法不存在
		public static const ExceptionCodeNotInstantiation : int = 20009;  //服务没有实例化
		
		public static const ErrorDb_PlayerIdError:int = 32000;//	玩家ID错误	2	0
		public static const ErrorDb_PlayerCreateUserNameExsit:int = 32001;//	账号已存在	2	0
		public static const ErrorDb_PlayerCreateRoleNameExsit:int	= 32002;//角色名已经存在	2	0
		
		public static const ErrorLogin_NeedLoginFromPlatform:int = 33000;//	请先登录平台	2	0
		public static const ErrorLogin_NoRole:int	= 33001;//		账号没有角色	2	0
		public static const ErrorLogin_RoleNameIsToLong:int = 33002;//		角色名太长	2	0
		public static const ErrorLogin_CreateRoleNameError:int=33003;//		角色名错误	2	0
		public static const ErrorLogin_CreateRoleDataError:int=33004;//		创建角色数据不正确	2	0
		public static const ErrorLogin_UserNameError:int=33005;//		错误的账号	2	0
		public static const ErrorGate_LoginNotLogin:int=35003;//			您还没有登陆，请刷新重试	2	0
		public static const ErrorGate_LoginIsLogin:int=35004;//			已经登陆服务器	2	0
		public static const ErrorGate_OperNotCD:int=35005;//			您的操作太快了	2	0
		public static const ErrorLogin_ErrorCodeVersion:int = 33006;		 // 代码版本错误
		
		
		public static function get map():Dictionary
		{
			return _map;
		}

	}
}