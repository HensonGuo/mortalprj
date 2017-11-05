package com.gengine.utils
{

	import com.gengine.debug.Log;
	import com.gengine.keyBoard.KeyBoardManager;
	import com.mui.controls.Alert;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.*;

	/**
	 * 主要用来判断变速齿轮的问题 加快客户端的速度  
	 * @author jianglang
	 * 
	 */	
	public class TimerTest extends Sprite
	{
		private var _sTime:Number;
		private var _dsTime:Number;
		private var _frame:int = 12; //帧频
		public static var Delay:Number = 40;
		private var MaxDelay:Number = 10000;
		private var _stage:Stage;
		private var _num:int = 0;
		private var _isAlert:Boolean = false;
		public static var tipText:String = "检测到当前系统时间被修改，若是手动修改，\n请刷新后再进行游戏";
		public function TimerTest(root:Stage):void
		{
			_frame = root.frameRate;
			_stage = root;
		}
		
		public function start():void
		{
			_sTime = getTimer();
			_dsTime = (new Date()).time;
			_stage.addEventListener(Event.ENTER_FRAME,onEventFrameHandler);		
		}

		private var i:int = 1;
		private function onEventFrameHandler(event:Event):void
		{
			i++;
			if (i > 5) 
			{
				i=1;
				testChangeTime();
			}
		}

		private function testChangeTime():void 
		{
			var eTime:Number = getTimer(); 
			var deTime:Number = (new Date()).time;
			
			var et:Number = eTime - _sTime;
			var dt:Number = deTime  - _dsTime;
			var delay:Number =  Math.abs( et - dt );
			Log.debug("delayTime:"+delay+"=="+[et,dt]);
			if ( delay > Delay && delay < MaxDelay)
			{
				_num++;
				if(_num>5)
				{
					if( _isAlert == false )
					{
						KeyBoardManager.instance.cancelListener();
						_isAlert = true;
						Alert.show(tipText,null,0,null,close);
//						return;
					}
				}
			}
			_sTime = eTime;
			_dsTime = deTime;
		}
		private function close(index:int):void
		{
			_isAlert = false;
			navigateToURL(new URLRequest("javascript:location.reload();"),"_self"); 
			_stage.removeEventListener(Event.ENTER_FRAME,onEventFrameHandler);	
		}
	} 
}