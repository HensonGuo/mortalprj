package core
{
	public class BaseError
	{
		public function BaseError()
		{
		}
		
		public static const NameNullError:int 		= -1001;
		public static const NameLengthError:int		= -1002;
		public static const NameExpError:int 			= -1003;
		public static const Success:int 				= 1;
		
		public static function getErrorStr(code:int):String
		{
			return errorStr[code.toString()];
		}

		public static function getErrorStr_tw(code:int):String
		{
			return errorStr_tw[code.toString()];
		}
		
		private static const errorStr:Object = {
			"-1001":"请输入角色名",
			"-1002":"角色名必须为2~7个字符",
			"-1003":"输入的角色名存在非法信息，如：QQ号,YY号",
			"1":"点击进入游戏"
		};
		
		private static const errorStr_tw:Object = {
			"-1001":"請輸入角色名",
			"-1002":"角色名必須為2~7个字符",
			"-1003":"輸入的角色名含非法字符，如：QQ號,YY號",
			"1":"點擊進入遊戲"
		}
	}
}