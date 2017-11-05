package com.gengine.debug
{
	public class GameStatistical
	{
		public static var drawTopMapNum:int;
		public static var drawBgMapNum:int;
		public static var draw3dNum:int;
		public static var sceneObjNum:int;
		public static var drawType:String;
		public static function reset():void
		{
			drawTopMapNum = 0;
			drawBgMapNum = 0;
		}
	}
}