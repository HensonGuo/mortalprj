package Engine.RMI
{
	import Framework.Util.Exception;

	public class RMIException extends Exception
	{
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

		
		public function RMIException( str : String = "RMIException" , code : int = ExceptionCodeRMI )
		{
			super( str , code );
		}
	}
}