/**
 * @date 2011-4-8 上午09:47:06
 * @author  wyang
 * 
 */  

package com.mui.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ToolTipPool 
	{
		private static var pools:Dictionary = new Dictionary();
		
		private static function getPool( type:Class ):Array
		{
			return type in pools ? pools[type] : pools[type] = new Array();
		}
		
		
		public static function getObject( type:Class, ...parameters ):*
		{
			var pool:Array = getPool( type );
			//缓存10个,为了提高tooltip流畅度添加
			if( pool.length > 10 )
			{
				return pool.pop();
			}
			else
			{
				return construct( type, parameters );
			}
		}
		
		public static function disposeObject( object:*, type:Class = null ):void
		{
			if(!object)
			{
				return;
			}
			if( !type )
			{
				var typeName:String = getQualifiedClassName( object );
				type = getDefinitionByName(typeName) as Class;
			}
			var pool:Array = getPool( type );
			pool.push( object );
		}
		
		private static function construct( type:Class, parameters:Array ):*
		{
			switch( parameters.length )
			{
				case 0:
					return new type();
				case 1:
					return new type( parameters[0] );
				case 2:
					return new type( parameters[0], parameters[1] );
				case 3:
					return new type( parameters[0], parameters[1], parameters[2] );
				case 4:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3] );
				case 5:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4] );
				case 6:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5] );
				case 7:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6] );
				case 8:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7] );
				case 9:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8] );
				case 10:
					return new type( parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9] );
				default:
					return null;
			}
		}
	}
}