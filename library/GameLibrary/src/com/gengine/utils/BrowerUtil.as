package com.gengine.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 浏览器工具类 
	 * @author jianglang
	 * 
	 */	
	public class BrowerUtil
	{
		public function BrowerUtil()
		{
			
		}
		/**
		 * 跳转  _brank:新界面  _self：本界面跳转
		 * @param url
		 * @param target
		 * 
		 */		
		public static function getUrl(url:String,target:String = "_blank"):void
		{
			if( url != null &&  url != "")
			{
				navigateToURL(new URLRequest(url),target);
			}
		}
		/**
		 * 刷新当前页面 
		 * 
		 */		
		public static function reload():void
		{
			navigateToURL(new URLRequest("javascript:location.reload();"),"_self");
		}
		
		/**
		 * 调用js字符串 
		 * 
		 */		
		public static function callJsStr(jsStr:String):void
		{
			navigateToURL(new URLRequest(jsStr),"_self");
		}
	}
}