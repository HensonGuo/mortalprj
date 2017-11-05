package com.gengine.utils
{
	import flash.utils.Dictionary;

	/**
	 * 有序的key-value结构
	 * @date   2014-3-27 下午8:57:21
	 * @author dengwj
	 */	 
	public class HashMap
	{
		private var _dic:Dictionary = new Dictionary(true);
		private var _keys:Array = new Array();
		
		public function HashMap()
		{
			
		}
		
		public function push(key:*, value:*):void
		{
			this._keys.push(key);
			this._dic[key] = value;
		}
		
		public function getValue(key:*):Object
		{
			return this._dic[key];	
		}
		
		public function remove(key:*):void
		{
			for(var i:int = 0; i < this._keys.length; i++)
			{
				if(this._keys[i] == key)
				{
					this._keys.splice(i,1);
					delete this._dic[key];
				}
			}
		}
		
		public function removeAll():void
		{
			this._keys.length = 0;
			for each(var key:Object in this._dic)
			{
				delete this._dic[key];
			}
		}	
		
		public function getKeys():Array
		{
			return this._keys;
		}
		
		public function get values():Array
		{
			var resultArr:Array = new Array();
			for each(var obj:Object in this._keys)
			{
				resultArr.push(this._dic[obj]);
			}
			return resultArr;
		}
		
		public function get length():int
		{
			return this._keys.length;
		}	
	}
}