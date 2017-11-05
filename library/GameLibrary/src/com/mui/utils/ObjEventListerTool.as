package com.mui.utils
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class ObjEventListerTool
	{
		private static var dicObjEvents:Dictionary = new Dictionary(true);
		
		public function ObjEventListerTool()
		{
		}

		/**
		 * 添加事件监听
		 * @param obj
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public static function addObjEvent(dispatcher:IEventDispatcher, type:String,listener:Function, useCapture:Boolean):void
		{
			if(!hasObjEvent(dispatcher))
			{
				dicObjEvents[dispatcher] = [];
			}
			var lisAry:Array = dicObjEvents[dispatcher];
			var lisObj:LisObj;
			for each(lisObj in lisAry)
			{
				if(lisObj.type == type && lisObj.listener == listener && lisObj.useCapture == useCapture)
				{
					return;
				}
			}
			lisObj = new LisObj(type,listener,useCapture);
			lisAry.push(lisObj);
		}
		
		public static function hasObjEvent(dispatcher:IEventDispatcher):Boolean
		{
			return dicObjEvents[dispatcher] != null && dicObjEvents[dispatcher] != undefined;
		}
		
		/**
		 * 移除事件监听 
		 * @param obj
		 * @param listener
		 * @param useCapture
		 * 
		 */		
		public static function removeObjEvent(dispatcher:IEventDispatcher,type:String, listener:Function, useCapture:Boolean):void
		{
			if(hasObjEvent(dispatcher))
			{
				var lisAry:Array = dicObjEvents[dispatcher];
				var length:int = lisAry.length;
				var lisObj:LisObj;
				for(var i:int = length - 1;i >= 0;i--)
				{
					lisObj = lisAry[i] as LisObj;
					if(lisObj.type == type && lisObj.listener == listener && lisObj.useCapture == useCapture)
					{
						lisAry.splice(i,1);
					}
				}
				//没有监听的时候删除key
				if(lisAry.length == 0)
				{
					delete dicObjEvents[dispatcher];
				}
			}
		}
		
		/**
		 * 删除一个对象的所有事件监听 
		 * @param obj
		 * 
		 */
		public static function delObjEvent(dispatcher:IEventDispatcher):void
		{
			if(hasObjEvent(dispatcher))
			{
				var lisAry:Array = dicObjEvents[dispatcher];
				var lisObj:LisObj;
				//删除事件
				for each(lisObj in lisAry)
				{
					dispatcher.removeEventListener(lisObj.type,lisObj.listener,lisObj.useCapture);
				}
				delete dicObjEvents[dispatcher];
			}
		}
	}
}

class LisObj
{
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	
	function LisObj($type:String,$listener:Function,$useCapture:Boolean)
	{
		type = $type;
		listener = $listener;
		useCapture = $useCapture;
	}
}