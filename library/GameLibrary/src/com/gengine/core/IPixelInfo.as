package com.gengine.core
{
	import flash.display.BitmapData;

	public interface IPixelInfo extends IDispose
	{
		function get bitmapData():BitmapData;
		function get id():String;
	}
}