package com.gengine.global
{
	import com.gengine.core.call.Caller;
	import com.gengine.core.frame.FrameManager;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.ui.Application;
	import com.mui.core.Library;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;

	/**
	 * 全局变量 
	 * @author jianglang
	 * 
	 */	
	public class Global
	{
		private static var _stage:Stage; //全局场景
		
		public static var isDebugModle:Boolean = false;
		
		public static var isActivate:Boolean = true;
		
		private var _caller:Caller = new Caller();
		private var _timer:FrameTimer;
		private static const CallerType:String = "render";
		
		private static var _instance:Global;
		
		public function Global()
		{
			if( _instance != null )
			{
				throw new Error("Global 单例");
			}
		}
		
		public static function get instance():Global
		{
			if( _instance == null )
			{
				_instance = new Global();
			}
			return _instance;
		}

		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static var application:Application;
		
		public function initStage(value:Stage):void
		{
			_stage = value;
			_stage.addEventListener(Event.RESIZE,onReSizeHandler,false,99999,false);
			_stage.addEventListener(Event.ACTIVATE,onActivateHandler,false,99999);
			_stage.addEventListener(Event.DEACTIVATE,onDeactivateHandler,false,99999);
			
			if(!_timer)
			{
				_timer = new FrameTimer();
			}
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			_timer.start();
		}
		
		/**
		 * enterFrame 
		 * @param timer
		 * 
		 */
		private function onEnterFrame(timer:FrameTimer):void
		{
			if(!timer.isRepair)
			{
				for each(var fun:* in _enterFrameArray)
				{
					(fun as Function).call(null);
				}
			}
		}
		
		private var _enterFrameArray:Array = new Array();
		
		public function addEnterFrame(callBack:Function):void
		{
			var index:int = _enterFrameArray.indexOf(callBack);
			if(index == -1)
			{
				_enterFrameArray.push(callBack);
			}
		}
		
		public function removeEnterFrame(callBack:Function):void
		{
			var index:int = _enterFrameArray.indexOf(callBack);
			if(index >= 0)
			{
				_enterFrameArray.splice(index,1);
			}
		}
		
		private function onRenderHandler(event:Event):void
		{
//			_isCallLater = false;
			_caller.call(CallerType);
			_caller.removeCallByType(CallerType);
		}
		
		private function onActivateHandler( event:Event ):void
		{
			_stage.focus = stage;
			isActivate = true;
		}
		
		private function onDeactivateHandler( event:Event ):void
		{
			isActivate = false;
		}
		
		private function onReSizeHandler( event:Event ):void
		{
			if( event.target is Stage == false )
			{
				event.stopImmediatePropagation();
			}
		}
		
		private var _isCallLater:Boolean = false;
		
		public function callLater(callback:Function):void
		{
			_caller.addCall(CallerType,callback);
//			if( _isCallLater == false )
//			{
				_stage.invalidate();
				_stage.addEventListener(Event.RENDER,onRenderHandler);
//				_isCallLater = true;
//			}
		}
		
		public function hasCallLater(callback:Function):Boolean
		{
			return _caller.hasCallFun(CallerType,callback);
		}
		
		public static function gc():void
		{
			try {  
				new LocalConnection().connect("foo");
				new LocalConnection().connect("foo");  
			} catch (e:*) {}
		}

	}
}