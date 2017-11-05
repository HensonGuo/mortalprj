package com.mui.controls
{
	import com.gengine.core.IDispose;
	
	import flash.events.IEventDispatcher;

	public interface ITabBar2Cell extends IDispose,IEventDispatcher
	{
		function set selected(value:Boolean):void;
		function set data(value:Object):void;
		function over():void;
		function out():void;
	}
}