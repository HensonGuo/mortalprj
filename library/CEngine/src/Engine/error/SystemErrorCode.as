package Engine.error
{
	import flash.utils.Dictionary;
	
	public class SystemErrorCode
	{
		
		private static var _map:Dictionary = new Dictionary();
		
		public static function getErrorByCode(value:int):String
		{
			return _map[value];
		}
		
		public static function isInError( code:int ):Boolean
		{
			return (code in _map);
		}
		
		public function SystemErrorCode()
		{
			
		}
		
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
		
		public static function get map():Dictionary
		{
			return _map;
		}
		
	}
}