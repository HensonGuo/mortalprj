package com.gengine.game.core
{
	import flash.display.BitmapData;

	public class BData implements IBData
	{
		private var _bitmapData:BitmapData;
		private var _url:String;
		private var _x:int;
		private var _y:int;
		
		public function BData(x:int,y:int,url:String,bitmapdata:BitmapData)
		{
			_bitmapData = bitmapdata;
			_url = url;
			_x = x;
			_y = y;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function get url():String
		{
			return _url;
		}

		public function get x():int
		{
			return _x;
		}

		public function get y():int
		{
			return _y;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			
		}

	}
}