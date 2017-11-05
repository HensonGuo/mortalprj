package com.gengine.utils
{
	import flash.utils.describeType;

	public class ObjectParser
	{
		public function ObjectParser()
		{
		}
		
		/**
		 * 简单类赋值 
		 * @param obj
		 * @param cls
		 * @return 
		 * 
		 */		
		public static function toClass( obj:Object ,cls:Class ):*
		{
			var item:* = new cls();
			putObject( obj,item );
			return item;
		}
		
		/**
		 * 简单类赋值 对象 
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */		
		public static function putObject( source:Object ,target:Object ):void
		{
			for( var key:* in source  )
			{
				if( target.hasOwnProperty(key) )
				{
					target[key] = source[key];
				}
			}
		}
		
		/**
		 * 数组、Dictionary是否每一个值相等 
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */		
		public static function isObjectTheSameValue(obj1:Object, obj2:Object):Boolean
		{
			for each(var key:* in obj1)
			{
				if(obj1[key] != obj2[key])
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 复制object 
		 * @param obj
		 * @return 
		 * 
		 */		
		public static function duplicate(obj:Object):Object
		{
			var dup:Object = new Object();
			for( var key:* in obj  )
			{
				dup[key] = obj[key];
			}
			return dup;
		}
		
		/**
		 * 返回cls的固定属性名列表
		 * @param cls
		 * @return 
		 * 
		 */		
		public static function getClassVars( cls:Object ):Array
		{
			var result:Array = [];
			var xml:XML = describeType(cls);
			if(xml)
			{
				var txml:XML;
				var vars:* = xml.variable;
				if(vars)
				{
					for each(txml in vars)
					{
						result.push(txml.attribute("name")[0].toString());
					}
				}
				vars = xml.accessor;
				if(vars)
				{
					for each(txml in vars)
					{
						result.push(txml.attribute("name")[0].toString());
					}
				}
			}
			return result;
		}
	}
}