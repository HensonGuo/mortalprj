package com.gengine.utils
{
	import com.gengine.debug.Log;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * 作用：加载过滤文本文件作为字符串 作为过滤字符串规则 
	 * @author jianglang
	 * 
	 */	
	public class FilterText extends EventDispatcher
	{
		
		private const MAX_LENGTH:int = 1000;
		
		private var _loader:URLLoader;
		private var _filterStr:String;
		private var _filterRegExp:RegExp;
		
		private var _splitReg:RegExp = /(\n|\r)+/mg;
		
		private var _wordMap:Dictionary;
		
		private static var _instance:FilterText;
		
		public function FilterText()
		{
			_loader = new URLLoader();
			_wordMap = new Dictionary();
		}
		
		public static function get instance():FilterText
		{
			if( _instance == null )
			{
				_instance = new FilterText();
			}
			
			return _instance;
		}
		
		/**
		 * 加载 过滤字符串文件 
		 * @param file
		 * 
		 */		
		public function load(file:String):void
		{
            var request:URLRequest = new URLRequest(file);
            try {
                _loader.load(request);
                addListener();
            } catch (error:Error) {
                Log.system("Unable to load requested document.");
            }
		}
		
		private function addListener():void
		{
			 _loader.addEventListener(Event.COMPLETE, completeHandler);
             _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function removelistener():void
		{
			 _loader.removeEventListener(Event.COMPLETE, completeHandler);
             _loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		/**
		 * 加载数据完成 生成过滤正则表达式 
		 * @param event
		 * 
		 */		
		private function completeHandler(event:Event):void
		{
			log("加载完成");
			removelistener();
            var loader:URLLoader = URLLoader(event.target);
           	createRegExpStr( String(loader.data) );
            dispatchEvent(event);
       	}
       	
       	private var _filterRegAry:Array = [];
       	
       	private function createRegExpStr(str:String):void
       	{
       		var tempAry:Array = str.split(_splitReg );
			var len:int = tempAry.length;
       		for( var i:int=0;i<len;i++ )
			{
				addWord(tempAry[i]);
			}
       	}
       	
       	public function ioErrorHandler(event:IOErrorEvent):void
       	{
       		Log.system(event);
       		dispatchEvent(event);
       	}
       	/**
       	 * 获取过滤后的字符串 
       	 * @param str
       	 * @return 
       	 * 
       	 */       	
       	public function getFilterStr(str:String):String
       	{
       		if(null==str||str=="") return "";
       		//根据正则替换字符串
			var len:int = str.length;
			var s:String;
			var ws:*;
       		for( var i:int=0;i<len;i++  )
			{
				s = str.charAt(i);
				if(s != "*")
				{
					ws = _wordMap[ s ];
					if( ws is String)
					{
						ws = _wordMap[ s ] = new RegExp( "("+ws+")","img" );
					}
					str = str.replace(ws,regHandler);
				}
			}
       		return str;
       	}
		
		/**
		 * 是否含有过滤关键字 
		 * @param str
		 * @return 
		 * 
		 */		
		public function isHaveFilterTxt(str:String):Boolean
		{
			var str2:String = getFilterStr(str);
			return !(str2 == str);
		}
		
       	/**
       	 * 处理过滤的函数 
       	 * @return 
       	 * 
       	 */       	
       	private function regHandler():String
       	{
       		//获取正则获取的字符串
       		//Log.system( arguments[1] );
			var s:String = arguments[1].toString();
			//替换成*
			return s.replace(/.{1}/g,"*");
       	}
       	
       	private function log(obj:Object):void
       	{
       		Log.system(obj);
       	}
       	
       	public function setFilterStr(str:String,splitReg:RegExp = null):void
       	{
			if( splitReg != null )
			{
				_splitReg = splitReg;
			}
       		createRegExpStr(str);
       	}
		
		public function clearWords():void
		{
			_wordMap = new Dictionary();
		}
		
		public function addWord( value:String ):void
		{
			value = value.replace("\n","");
			if(value != null && value.length > 0)
			{
				var dic:String;
				var s:String = value.charAt(0);
				dic = _wordMap[s] as String;
				if( dic )
				{
					_wordMap[s] += "|"+value;
				}
				else
				{
					_wordMap[s] = value;
				}				
			}
		}
	}
}