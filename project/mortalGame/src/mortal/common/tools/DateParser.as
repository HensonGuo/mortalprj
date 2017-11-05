/**
 * @date 2011-4-14 下午05:54:26
 * @author  hexiaoming
 *
 */
package mortal.common.tools
{

	public class DateParser
	{
		private static var _date:Date = new Date();
		private static var _parserList:Array = 
			[
				{fun:yyyy,str:"yyyy"},	//4位年份
				{fun:yy,str:"yy"},		//2位年份
				{fun:y,str:"y"},		//1位年份
				{fun:MM,str:"MM"},		//含有前导零月份
				{fun:M,str:"M"},		//不含有前导零月份
				{fun:dd,str:"dd"},		//含有前导零日期
				{fun:d,str:"d"},		//不含有前导零日期
				{fun:hh,str:"hh"},		//含有前导零小时
				{fun:h,str:"h"},		//不含有前导零小时
				{fun:mm,str:"mm"},		//含有前导零分钟
				{fun:m,str:"m"},		//不含有前导零分钟
				{fun:ss,str:"ss"},		//含有前导零秒钟
				{fun:s,str:"s"}			//不含有前导零秒钟
			];
		public static function parse(date:Date,str:String):String
		{
			_date = date;
			for(var i:int = 0;i<_parserList.length;i++)
			{
				var obj:Object = _parserList[i];
				str = str.replace(obj.str,(obj.fun as Function).call());
			}
			return str;
		}
		
		/**
		 * 把字符串转成Date类型 
		 * @param str 日期的字符串，eg:2010-01-01 00:00:00.000
		 * @return 
		 * 
		 */		
		public static function strToDate( str:String ):Date 
		{
			//get each number in an array
			var match:Array = str.match( /\d+/g );
			
			//if there were no miliseconds, add 0 to the end
			while( match.length < 7 )
			{
				match.push('0');
			}
			
			return new Date( Number(match[0]), Number(match[1]), Number(match[2]), Number(match[3]), Number(match[4]), Number(match[5]), Number(match[6]) );
		}
		
		/**
		 * 把字符串转成Date类型 （字符串月份按01 02 --- 12正常传入）
		 * @param str 日期的字符串，eg:2010-01-01 00:00:00.000
		 * @return 
		 * 
		 */		
		public static function strToDateNormal( str:String ):Date 
		{
			//get each number in an array
			var match:Array = str.match( /\d+/g );
			
			//if there were no miliseconds, add 0 to the end
			while( match.length < 7 )
			{
				match.push('0');
			}
			
			return new Date( Number(match[0]), Number(match[1]) - 1, Number(match[2]), Number(match[3]), Number(match[4]), Number(match[5]), Number(match[6]) );
		}
		
		private static function yyyy():String
		{
			return _date.fullYear.toString();
		}
		
		private static function yy():String
		{
			return _date.fullYear.toString().slice(2);
		}
		
		private static function y():String
		{
			return _date.fullYear.toString().slice(3);
		}
		
		private static function MM():String
		{
			return (_date.getMonth() + 1< 10 ? "0" : "") + (_date.getMonth() + 1);
		}
		
		private static function M():String
		{
			return (_date.getMonth() + 1).toString();
		}
		
		private static function dd():String
		{
			return (_date.getDate()< 10 ? "0" : "") + _date.getDate();
		}
		
		private static function d():String
		{
			return _date.getDate().toString();
		}
		
		private static function hh():String
		{
			return (_date.getHours()< 10 ? "0" : "") + _date.getHours();
		}
		
		private static function h():String
		{
			return _date.getHours().toString();
		}
		
		private static function mm():String
		{
			return (_date.getMinutes()< 10 ? "0" : "") + _date.getMinutes();
		}
		
		private static function m():String
		{
			return _date.getMinutes().toString();
		}
		
		private static function ss():String
		{
			return (_date.getSeconds()< 10 ? "0" : "") + _date.getSeconds();
		}
		
		private static function s():String
		{
			return _date.getSeconds().toString();
		}
	}
}