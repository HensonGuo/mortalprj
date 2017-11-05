package com.mui.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public interface IDragDrop extends IEventDispatcher 
	{
		function get dragSource():Object;
		function set dragSource(value:Object):void;
		
		function get isDragAble():Boolean;//是否可以拖动
		function get isDropAble():Boolean;//是否可以拖放到此物品上
		function get isThrowAble():Boolean;//是否可以丢弃
		function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean;//是否可以把些物品放到上面
	}
}