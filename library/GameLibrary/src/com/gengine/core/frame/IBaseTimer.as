package com.gengine.core.frame
{
	import com.gengine.core.IDispose;

	public interface IBaseTimer extends IDispose
	{
		function get type():String;
		/**
		 * 是否需要渲染 
		 * @return 
		 * 
		 */		
		function get running():Boolean;
		/**
		 * 获取标识符ID 
		 * @return 
		 * 
		 */		
		function get id():int;
		/**
		 * 删除计时器 
		 * @return 
		 * 
		 */		
		function get isDelete():Boolean;
		
		/**
		 * 开始启动 
		 * 
		 */		
		function start():void;
		
		/**
		 * 停止 
		 * 
		 */		
		function stop():void;
		
		/**
		 * 时间间隔设置 
		 * @return 
		 * 
		 */		
		function get delay():Number;
		function set delay(value:Number):void;
		
		/**
		 *  重复执行次数设置
		 * @return 
		 * 
		 */		
		function get repeatCount():Number;
		function set repeatCount(value:Number):void;
		
		function addListener(type:String,callback:Function):void;
		
		function renderer(frame:int,isRepair:Boolean = false):void;
		
		function get isTimerQueue():Boolean;
		function set isTimerQueue(value:Boolean):void;
		
		function get interval():int;
		function set interval( value:int ):void;
		
		function get isRepair():Boolean;
		function set isRepair(value:Boolean):void
	}
}