package com.gengine.ui.timer
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 游戏时钟类 计算时间 
	 * @author jianglang
	 * 
	 */	
	public class GameClock extends Sprite
	{
		private var _year:int; 	//年
		private var _month:int; 	// 月
		private var _date:int; 	// 日
		private var _hours:int; 	// 小时
		private var _minutes:int; 	// 分钟
		private var _seconds:int; 	//秒
		
		private var _time:Number;    //毫秒
		
		private var _nowDate:Date;
		
		private var _secTimer:SecTimer;
		
		private var _label:TextField;
		
		public var enterFrameHandler:Function;
		
		public function GameClock()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_label = new TextField();
			_label.mouseEnabled = false;
			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.defaultTextFormat = new TextFormat(null,12);
			this.addChild(_label);
			_secTimer = new SecTimer();
			_secTimer.addListener(TimerType.ENTERFRAME,onEnterFrameHandler);
		}
		
		public function get nowDate():Date
		{
			if(!_nowDate)
			{
				_nowDate = new Date();
			}
			return _nowDate;
		}

		private function onEnterFrameHandler( timer:SecTimer ):void
		{
			_nowDate.seconds += 1; 
			if( this.parent )
			{
				_label.text = getDateStr();
			}
			if( enterFrameHandler is Function )
			{
				enterFrameHandler(_nowDate);
			}
		}
		
		public function set time( value:Object ):void
		{
			if( value is Date )
			{
				_nowDate = value as Date;
			}
			else if( value is Number )
			{
				_time = value as Number;
				_nowDate = new Date( _time );
			}
			
			if( _secTimer.running == false )
			{
				_secTimer.start();
			}
		}
		
		private function getDateStr():String
		{
			var str:String = "";
			str += _nowDate.fullYear+"-";
			if( _nowDate.month < 10 )
			{
				str += "0";
			}
			str += (_nowDate.month+1)+"-";
			if( _nowDate.date < 10 )
			{
				str += "0";
			}
			str += _nowDate.date+"  ";
			
			if( _nowDate.hours < 10 )
			{
				str += "0";
			}
			str += _nowDate.hours+":";
			if( _nowDate.minutes < 10 )
			{
				str += "0";
			}
			str += _nowDate.minutes+":";
			if( _nowDate.seconds < 10 )
			{
				str += "0";
			}
			str += _nowDate.seconds;
			
			return str;
			
		}
		
		
	}
}