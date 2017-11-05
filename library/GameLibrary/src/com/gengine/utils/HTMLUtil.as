/**
 * @date	2011-3-12 下午03:03:41
 * @author  jianglang
 * 
 */	

package com.gengine.utils
{
	public class HTMLUtil
	{
		private static var delHtmlreg:RegExp = new RegExp("\<\/?[^\<\>]+\>","gmi");
		private static var replaceTagLeft:RegExp = new RegExp("<", "g");
		private static var replaceTagRight:RegExp = new RegExp(">", "g");
		
		public function HTMLUtil()
		{
			
		}
		
		/**
		 * 替换html标签"< >" 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function replaceHtmlTag(str:String):String
		{
			str = str.replace(replaceTagLeft, "&lt;");
			str = str.replace(replaceTagRight, "&gt;");
			return str;
		}
		
		public static function addColor( str:String , color:String ,fontName:String = ""):String
		{
			var strHtml:String = "<font color='"+color+"'";
			if(fontName != "")
			{
				strHtml += " face='" + fontName + "'";
			}
			strHtml += ">"+ str +"</font>";
			return strHtml;
		}
		
		public static function removeHtml(str:String):String
		{
			if(str)
			{
				return str.replace(delHtmlreg,"");
			}
			return "";
		}
		
		/**
		 * 综括号替换成Html 
		 * @param str
		 * 
		 */
		public static function getHtmlByComp(str:String):String
		{
			return str.replace(/\[/g,"<").replace(/\]/g,">");
		}
	}
}
