package com.mui.core
{
	import com.gengine.core.IDispose;

	public interface IFrUI extends IDispose
	{
		/** 监听事件*/
		function configEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
	}
}