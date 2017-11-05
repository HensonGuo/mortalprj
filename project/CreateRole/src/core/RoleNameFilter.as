package core
{
	import utils.StringUtil;

	public class RoleNameFilter
	{
		public static const nameFilterExp:String = "[^1234567890i0l零壹贰叁肆伍陆柒捌玖一二三四五六七八九OZzo]";
		public static const nameFilterRestrict:String = "\u4E00-\u9FA5\u0020-\u007E·-=【】；‘、，。、.~！@#￥%……&*（）——+{}：’“”|《》？/*.‘’";
		
		public function RoleNameFilter()
		{
		}
		
		public static function filterName(str:String):int
		{
			str = StringUtil.trim(str);
			if(str == "")
			{
				return BaseError.NameNullError;
			}
			else if(str.length < 2)
			{
				return BaseError.NameLengthError;
			}
			else if(nameFilterCheck(str))
			{
				return BaseError.NameExpError;
			}
			return BaseError.Success;
		}
		
		private static function nameFilterCheck(str:String):Boolean
		{
			var nameReg:RegExp = new RegExp(nameFilterExp,"img");
			str = str.replace(nameReg,"");
			return str.length >= 4;
		}
	}
}