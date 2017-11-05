package com.gengine.debug
{
	import com.gengine.core.FrameUtil;
	import com.gengine.core.frame.FlashFrame;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * 这个类提供了FPS监控功能，可以用作性能优化的标准
	 * 
	 * @author flashyiyi
	 */	
	public class FPS extends Sprite
	{
		/**
		 * 采样次数
		 */		
		public var sampling:int = 30;
		
		/**
		 * 默认帧频，为0时则取舞台帧频
		 */		
		public var frameRate:int = 0;
		
		private var fpsTextField:TextField;
		private var secTextField:TextField;
		
		private var fpsBmp:Bitmap;
		private var secBmp:Bitmap;
		
		private var intervalArr:Array=[];
		
		private var _totalFrame:int=0;
		
		private var _totalTimer:int = 0;
		
		private static var _instance:FPS = new FPS();
		
		public function FPS()
		{
			if( _instance )
			{
				throw new Error(" FPS单例");
			}
			
			mouseEnabled = mouseChildren = false;
        	
			fpsTextField = new TextField();
			fpsTextField.x = 5;
			fpsTextField.mouseEnabled = false;
			fpsTextField.width = 350;
			fpsTextField.autoSize = TextFieldAutoSize.LEFT;
			fpsTextField.multiline = true;
			fpsTextField.height = 20;
			fpsTextField.selectable = false;
			fpsTextField.defaultTextFormat = new TextFormat(null,null,0xFFFFFF);
			addChild(fpsTextField);
			
//			fpsBmp = new Bitmap();
//			fpsBmp.x = 5;
//			this.addChild(fpsBmp);
			
			secTextField = new TextField();
			secTextField.x = 5;
			secTextField.y = 40;
			secTextField.mouseEnabled = false;
			secTextField.width = 350;
			secTextField.autoSize = TextFieldAutoSize.LEFT;
			secTextField.multiline = true;
			secTextField.height = 20;
			secTextField.selectable = false;
			secTextField.defaultTextFormat = new TextFormat(null,null,0xFFFFFF);
			addChild(secTextField);
			
//			secBmp = new Bitmap();
//			secBmp.x = 5;
//			secBmp.y = 40;
//			this.addChild(secBmp);
			
			this.x = 600;
			
			this.graphics.beginFill(0x000000,0.3);
			this.graphics.drawRect(0,0,350,80);
			this.graphics.endFill();
			this.cacheAsBitmap = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			if(!_timer)
			{
				_timer = new FrameTimer(30);
				_timer.addListener(TimerType.ENTERFRAME,tickHandler);
			}
			_timer.start();
			
			if(!_secTimer)
			{
				_secTimer = new SecTimer();
				_secTimer.addListener(TimerType.ENTERFRAME,secTimerHandler);
			}
			_secTimer.start();
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			if(_timer)
			{
				_timer.stop();
			}
			if(_secTimer)
			{
				_secTimer.stop();
			}
		}
		
		public static function get instance():FPS
		{
			return _instance;
		}
		
		public var entityNum:int;
		
		public var countFrames:int;
		
		public var pixleCount:Number = 0;
		
		public var fpsNum:int=0;
		
		private function tickHandler(event:FrameTimer):void
		{
			if (stage==null) 
			{
				return;
			}
				
			fpsNum=int(1000/FlashFrame.AverageTime);
			
			var str:String = "FPS：" + fpsNum +" | Memory："+currentMem.toFixed(3)+" | 帧数："+countFrames+ " | 对象："+entityNum;
			str += "<br>渲染模式：" + GameStatistical.drawType + " |顶图渲染：" + GameStatistical.drawTopMapNum + " |场景渲染：" + GameStatistical.draw3dNum;
			//str += "<br>模型大小："+pixleCount.toFixed(3)+"M  | 资源大小："+(ResourceInfo.resCount/(1024*1024)).toFixed(3);
			str += " |场景人数：" + GameStatistical.sceneObjNum;
			fpsTextField.htmlText = str;
			
//			var bitmapData:BitmapData = new BitmapData(300,40,true,0x00FFFFFF);
//			bitmapData.draw(fpsTextField);
//			if(fpsBmp.bitmapData )
//			{
//				fpsBmp.bitmapData.dispose();
//			}
//			fpsBmp.bitmapData = bitmapData;
		}
		
		private function secTimerHandler(event:SecTimer):void
		{
			if (stage==null) 
				return;
			
			var str:String = "";
			str += "<br>消息：" + FrameUtil.messageProTimer + " | 帧：" + FrameUtil.frameProTimer + " | 时间：" + FrameUtil.timerProTimer + " | 深度：" + FrameUtil.sortProTimer + " | 显卡：" + FrameUtil.driveInfo;
			secTextField.htmlText = str;
			
//			var bitmapData:BitmapData = new BitmapData(300,40,true,0x00FFFFFF);
//			bitmapData.draw(secTextField);
//			if(secBmp.bitmapData)
//			{
//				secBmp.bitmapData.dispose();
//			}
//			secBmp.bitmapData = bitmapData;
			
			FrameUtil.messageProTimer = 0;
			FrameUtil.frameProTimer = 0;
			FrameUtil.sortProTimer = 0;
			FrameUtil.timerProTimer = 0;
		}
		
		public static function get currentMem() : Number 
		{
			return (System.totalMemory / 1024) / 1024;
		}
		
		private var _timer:FrameTimer;
		private var _secTimer:SecTimer;
		
		public function show():void
		{
			if( this.stage == null )
			{
				Global.stage.addChild(this);
			}
		}
		
		public function hide():void
		{
			if( this.stage )
			{
				Global.stage.removeChild(this);	
			}
		}
	}
}