package com.gengine.manager
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	/**
	 * 通过JS与浏览器通讯
	 * 
	 * @author jianglang
	 * 
	 */
	public class BrowerManager
	{
		//[Embed(source = "BrowerManager.js",mimeType="application/octet-stream")]
		//private static var jsCode:Class;
		//ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		private static var _instance:BrowerManager;
		
		public function BrowerManager()
		{
			if( _instance != null )
			{
				throw "BrowerManager 为单例";
			}
		}
		
		public static function get instance():BrowerManager
		{
			if( _instance == null )
			{
				_instance = new BrowerManager();
			}
			return _instance;
		}
		
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public function get url():String
        {
			if (!ExternalInterface.available) 
				return null;
			try
			{
        		return ExternalInterface.call("Brower.getURL");
			}
			catch(e:Error){}
			return "";
		};
        /**
         * 浏览器除去参数后的地址
         * @return 
         * 
         */        
        public function get baseUrl():String
        {
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = this.url;
        	var p:int = url.indexOf("#");
        	if (p>0)
        		return url.substr(0,p - 1);
        	else
        		return url;
        }
		
		/**
		 * 调用js函数 
		 * @param jsFun
		 * 
		 */		
		public function asCallJsFun(jsFun:String):Boolean
		{
			if (!ExternalInterface.available) 
				return false;
			try
			{
				ExternalInterface.call(jsFun);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
        /**
         * 浏览器标题
         * @param v
         * 
         */        
        public function set title(v:String):void
        {
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("Brower.setTitle",v);
			}
			catch(e:Error){}
        };
        public function get title():String
        {
			if (!ExternalInterface.available) 
				return null;
			try
			{
				return ExternalInterface.call("Brower.getTitle");
			}
			catch(e:Error){}
			return "";
        };
        /**
         * 浏览器地址栏参数
         * @param values
         * 
         */        
        public function set urlVariables(values:URLVariables):void
        {
			if (!ExternalInterface.available) 
				return;
			
			var url:String = "";
        	var para:String = values.toString();
        	if (para.length>0)
        	 	url += "#" + para;
			try
			{
				ExternalInterface.call("Brower.setUrlVariables",url);
			}
			catch(e:Error){}
        }
        public function get urlVariables():URLVariables
        {
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = this.url;
        	var p:int = url.indexOf("#");
        	if (p>0)
        		return new URLVariables(url.substr(p + 1));
        	else
        		return new URLVariables();
        }
        /**
         * 加入收藏夹 
         * @param url
         * @param title
         * 
         */        
        public function addFavorite(title:String=null,url:String=null):void
        {
			if (!ExternalInterface.available) 
				return;
			 
			if (!url) 
        		url = this.url;    
			
        	if (!title)
        		title = this.title;
        		
			try
			{
        		ExternalInterface.call("Brower.addFavorite",url,title);
			}
			catch(e:Error)
			{
				
			}
        }
        /**
         * 设为主页
         * @param url
         * 
         */        
        public function setHomePage(url:String=null):void
        {
			if (!ExternalInterface.available) 
				return;
			
			if (!url)
        		url = this.url;
			try
			{
				ExternalInterface.call("Brower.setHomePage",url);
			}
			catch(e:Error){}
        }

		/**
         * 设置cookie
         * 
         * @param name           cookie名称
		 * @param value          cookie值
		 * @param expires        cookie过期时间
		 * @param security       是否加密
         */
        public function setCookie(name:String, value:String, expires:Date=null, security:Boolean=false):void
        {
			if (!ExternalInterface.available) 
				return;
			
			expires || (expires = new Date(new Date().time + (1000 * 86400 * 365)));
			try
			{
				ExternalInterface.call("Brower.setCookie",name,value,expires.time,security);
			}
			catch(e:Error){}
        }
        
        /**
         * 读取cookie
         * 
         * @param name	cookie名称
         * @return 
         * 
         */        
        public function getCookie(name:String):String
        {
			if (!ExternalInterface.available) 
				return null;
			try
			{
				return ExternalInterface.call("Brower.getCookie",name);
			}
			catch(e:Error){}
			return "";
        }
        
        /**
         * 在浏览器关闭时提供确认提示
         * 
         */
        public function confirmClose(text:String = "确认退出？"):void
        {
			if (!ExternalInterface.available)
				return;
			
			if (text)
			{
				try
				{
					ExternalInterface.call("Brower.confirmClose",text);
				}
				catch(e:Error){}
			}	
			else
			{
				try
				{
					ExternalInterface.call("Brower.confirmClose");
				}
				catch(e:Error){}
			}
			
		}
		
		/**
		 * 弹出警示框
		 * @param text
		 * 
		 */
		public function alert(...params):void
		{
			if (!ExternalInterface.available) 
				return;
			
			try
			{
				ExternalInterface.call("alert",params.toString());
			}
			catch(e:Error){}
		}
		
		/**
		 * 刷新浏览器 
		 * 
		 */
		public function reload():void
		{
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("location.reload");
			}
			catch(e:Error){}
		}
		
		/**
		 * 消除浏览器的滚动事件干扰 
		 * 
		 */
		public function disableScroll(objId:String = null):void
		{
			if (!ExternalInterface.available) 
				return;
			try
			{
				ExternalInterface.call("Brower.disableScroll",objId);
			}
			catch(e:Error){}
			
		}
		
		/**
		 * 打开地址（支持javascript:写法）
		 * 
		 * @param url
		 * @return 
		 * 
		 */
		public function getUrl(url:String,target:String = "_self"):void
		{
			if (url.substr(0,11) == "javascript:" && ExternalInterface.available)
			{
				var js:String = url.substr(11);
				if (url.indexOf("(") == -1 && url.indexOf(")") == -1)
					js += "()";
				try
				{
					ExternalInterface.call("eval",js);
				}
				catch(e:Error){}
			}
			else
			{
				navigateToURL(new URLRequest(url),target);
			}
		}
	}
}



