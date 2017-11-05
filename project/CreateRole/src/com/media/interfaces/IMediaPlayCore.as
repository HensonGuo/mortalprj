package com.media.interfaces
{
	
	/**
	 * ... 媒体播放核心接口类 ...
	 * 
	 * ************************************** 作者信息 *******************************************
	 * @author: 李振宇
	 * QQ: 39055299
	 * E-mail: cosmos53076@163.com
	 * Webpage: http://hi.baidu.com/cosmos53076
	 */
	public interface IMediaPlayCore 
	{
		/**
		 * 播放方法
		 */
		function play():void
		
		/**
		 * 暂停方法
		 */
		function pause():void
		
		/**
		 * 恢复方法
		 */
		function resume():void
		
		/**
		 * 停止方法
		 */
		function stop():void
		
		/**
		 * 播放时间搜索方法
		 * @param	time
		 */
		function seek(time:Number = 0):void
		
		/**
		 * 播放百分比搜索方法
		 * @param	percent
		 */
		function seekPercent(percent:Number = 0):void
		
		/**
		 * 销毁方法
		 */
		function dispose():void
	}
	
}