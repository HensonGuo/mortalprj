package com.gengine.game.core
{
	import com.gengine.core.IDispose;
	
	import flash.display.BitmapData;

	/**
	 *  BitmapData 信息
	 * @author jianglang
	 * 
	 */	
	public interface IBData extends IDispose
	{
		function get bitmapData():BitmapData;
		function get url():String;
		function get x():int;
		function get y():int;
	}
}