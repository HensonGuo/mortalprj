package Framework.Util
{
	public class Exception extends Error
	{
		
		public static const ExceptionCodeSystemBase : int = 10000 ;
		public static const ExceptionCodeRMIBase : int = 20000 ;
		public static const ExceptionCodeUserBase : int = 30000 ;
		
	  	public static const ExceptionCodeUnkown : int = 10000 ;    //未知异常
		public static const ExceptionOutOffMemery : int = 10001;   //内存不足
		public static const ExceptionCodeBase : int = 10002;       //基础库异常
		public static const ExceptionCodeStd : int = 10003;        //标准库异常
		public static const ExceptionCodeDateTime : int = 10004;   //日期格式异常
		public static const ExceptionCodeFunction : int = 10005;   //基本函数异常
		public static const ExceptionCodeNullHandle : int = 10006; //空句柄异常
		public static const ExceptionCodeDB : int = 10007;         //数据库异常
		public static const ExceptionCodeSerialize : int = 10008;  //序列化异常
		public static const ExceptionCodeLang : int = 10009;       //语言包异常
		public static const ExceptionCodeXml : int = 10010;        //XML异常
		
		public function Exception( str : String = "Exception" , code : int = ExceptionCodeBase )
		{
			this.message = str ;
			this.code = code;
		}
		public function get code() : int 
		{
			return _code;
		}
		public function set code( code : int ) : void
		{
			_code = code;
		}
		public function get method() : String 
		{
			return _method;
		}
		public function set method( method : String ) : void
		{
			_method = method;
		}
		private var _code : int ;
		private var _method : String;
	}
}