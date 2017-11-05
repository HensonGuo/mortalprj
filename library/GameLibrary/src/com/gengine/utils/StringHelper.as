package com.gengine.utils
{
	public class StringHelper
	{
		public function StringHelper()
		{
		}
		
		
		public static function getCharLength(str:String):int
		{
			var len:int = str.length;
			var mlen:int=0;
			for(var i:int=0;i<len;i++)
			{
				var n:Number = str.charCodeAt(i);
				if(n > 255||n<0)
				{
					mlen += 2;
				}else
				{
					mlen += 1;
				}
			}
			return mlen;
		}
		
		public static function trim(str:String):String
		{
			if (str == null) return '';
			
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case "":
				case " ":
				case "　":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		public static function getString( value:String ):String
		{
			return value == null?"":value;
		}
		/**
		 * 正则替换符号
		 * @param str
		 * @param rest
		 * @return 
		 * 
		 */		
		public static function substitute(str:String, ... rest):String
		{
			if (str == null) return '';
			
			// Replace all of the parameters in the msg string.
			var len:uint = rest.length;
			var args:Array;
			if (len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
			}
			
			return str;
		}
	}
}