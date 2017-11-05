package com.gengine.debug
{
	import com.gengine.FConfig;

	/**
	 * 日志 
	 * @author jianglang
	 * 
	 */	
	public class Log
	{
		
		public static var isSystem:Boolean = true;
		public static var isError:Boolean = true;
		public static var isDebug:Boolean = true;
		public static var isWarn:Boolean = true;
		public static var isAssert:Boolean = true;
		
		public static var debugLog:ILog;
		
		public function Log()
		{
			
		}
		
		/**
		 *  系统测试信息
		 * @param arguments
		 * 
		 */
		public static function system( ...rest ):void
		{
			CONFIG::Debug
			{
				if( isSystem )
				{
					trace(rest);
				}
			}
		}
		
		/**
		 * 错误信息 
		 * @param arguments
		 * 
		 */
		public static function error( ...rest ):void
		{
			if( debugLog )
			{
				debugLog.error(rest);
			}
			system(rest);
		}
		/**
		 * 调试信息 
		 * @param arguments
		 * 
		 */		
		public static function debug( ...rest ):void
		{
			if( isDebug )
			{
				if( debugLog )
				{
					debugLog.print(rest);
				}
				system(rest);
			}
		}
		/**
		 * 警告信息 
		 * @param arguments
		 * 
		 */		
		public static function warn( ...rest ):void
		{
			if( isWarn )
			{
				if( debugLog )
				{
					debugLog.print(rest);
				}
				system(rest);
			}
		}
		/**
		 * 断言
		 * @param experssion
		 * @param description
		 * 
		 */	
		public static function assert(expression:Boolean, description:String = null):void
		{
			if (!isAssert)
				return;
			if (!expression)
			{
				throw new Error(description);
			}
		}
		
		public static function closeAll():void
		{
			isDebug = false;
			isError = false;
			isSystem = false;
			isWarn = false;
			isAssert = false;
		}
		
		public static function openAll():void
		{
			isDebug = true;
			isError = true;
			isSystem = true;
			isWarn = true;
			isAssert = true;
		}
	}
}