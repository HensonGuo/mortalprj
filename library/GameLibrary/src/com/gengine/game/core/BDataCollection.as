package com.gengine.game.core
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * bitmapdata 对象集合 
	 * @author jianglang
	 * 
	 */	
	public class BDataCollection
	{
		
		private static var _instance:BDataCollection;
		
		public var collection:Dictionary;
		
		public function BDataCollection()
		{
			if ( _instance != null )
			{
				throw new Error( "BitmapDataCollection is a singleton. ");
			}
			collection = new Dictionary();
		}
		
		
		public static function get instance():BDataCollection
		{
			if ( _instance == null )
			{
				_instance = new BDataCollection();
			}
			return _instance;
		}
		
		/**
		 * 添加一个bitmapdata对象 
		 * @param id
		 * @param bitmapData
		 * @return 
		 * 
		 */		
		public function addBitmapData(info:IBData ):BitmapData
		{	
			collection[ info.url ] = info;
			return info.bitmapData;
		}
		
		/**
		 * 搜索一个bitmapdata对象是否存在 
		 * @param item
		 * @return 
		 * 
		 */		
		public function search( item:String ):Boolean
		{
			if ( collection[ item ] )
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			for each( var bmd:IBData in collection )
			{
				bmd.dispose();
				delete collection[bmd.url];
				bmd = null;
			}
			collection = new Dictionary();
		}
		
		/**
		 * 删除一个对象  id 或者 IBitmapDataInfo对象
		 * @param bitmapData
		 * @return 
		 * 
		 */		
		public function removeBitmapData( value:* ):Boolean
		{
			var bmd:IBData;
			if( value is String )
			{
				bmd = collection[ value ] as IBData;
				bmd.dispose();
				delete collection[ value ];
				return true;
			}
			else if( value is IBData )
			{
				bmd = value as IBData;
				bmd.dispose();
				delete collection[ bmd.url ];
				return true;
			}
			return false;
		}
		
	}
		
}