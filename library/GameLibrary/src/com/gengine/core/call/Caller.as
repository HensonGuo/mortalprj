package com.gengine.core.call
{
	import com.gengine.utils.ArrayUtil;
	
	import flash.utils.Dictionary;
	
	public class Caller implements ICaller
	{
		private var _callerMap:Dictionary;
		private var _callerIng:Dictionary;
		private var _removeLater:Array;
		
		public function Caller()
		{
			_callerMap = new Dictionary(true);
			_callerIng = new Dictionary(true);
			_removeLater = [];
		}
		/**
		 * 添加一个call 
		 * @param type
		 * @param value
		 * 
		 */		
		public function addCall( type:Object , value:Function ):void
		{
			var list:Array = getlistByType(type);
			list.push(value);
		}
		
		/**
		 *  
		 * @param type
		 * @param value
		 * 
		 */		
		public function hasCallFun(type:Object,value:Function):Boolean
		{
			var list:Array = getlistByType(type);
			return list.indexOf(value) >= 0;
		}
		
		/**
		 * 删除一个call 
		 * @param type
		 * @param value
		 * 
		 */		
		public function removeCall( type:Object , value:Function ):void
		{
			if(_callerIng.hasOwnProperty(type))
			{
				_removeLater.push(value);
				return;
			}
			var list:Array = _callerMap[type] as Array;
			if( list && list.length>0 )
			{
				ArrayUtil.removeItem(list,value);
			}
		}
		
		/**
		 * 执行一个call 
		 * @param type
		 * @param rect
		 * @param return
		 * 
		 */		
		public function call( type:Object , ...rect ):Boolean
		{
			var list:Array = _callerMap[type] as Array;
			if( list && list.length > 0 )
			{
				_callerIng[type] = type;
				for each( var fun:Function in list)
				{
					fun.apply( null , rect );
				}
				delete _callerIng[type];
				while(_removeLater.length > 0)
				{
					ArrayUtil.removeItem(list,_removeLater.shift());
				}
			}
			return true;
		}
		/**
		 *  销毁
		 * 
		 */		
		public function dispose(isReuse:Boolean=true):void
		{
			var list:Array;
			for ( var key:String in _callerMap )
			{
				list = _callerMap[key] as Array;
				list.length = 0;
				delete _callerMap[key];
			}
		}
		
		
		private function getlistByType( type:Object ):Array
		{
			if( type in _callerMap )
			{
				return _callerMap[type];
			}
			var ary:Array = new Array();
			_callerMap[type] = ary;
			return ary;
		}
		
		
		public function removeCallByType(type:Object):void
		{
			var list:Array = _callerMap[type] as Array;
			if( list )
			{
				list.length = 0;
				delete _callerMap[type];
			}
		}
		
		
		public function hasCall(type:Object):Boolean
		{
			return type in _callerMap;
		}
	}
}