package mortal.game.manager.msgTip
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.LayerManager;

	public class MsgCopyTaskEndImpl
	{
		private var _wordTxt:TextField;
		private var _str:String;
		private var _daily:int;
		private var _count:int;
		private var _currentCount:int;
		private var _callBack:Function;
		private var _timer:SecTimer;
		
		public function MsgCopyTaskEndImpl()
		{
		}
		
		/**
		 * 停止计时器 
		 * 
		 */
		private function stopTimer():void
		{
			if(_timer && _timer.running)
			{
				_timer.stop();
				_timer.isDelete = false;
			}
		}
		
		/**
		 * 开启计时器 
		 * 
		 */
		private function startTimer():void
		{
			if(!_timer)
			{
				_timer = new SecTimer(_daily,_count * _daily);
				_timer.addListener(TimerType.ENTERFRAME,onTimerHandler);
				_timer.addListener(TimerType.COMPLETE,onTimerComHandler);
			}
			else
			{
				_timer.delay = _daily;
				_timer.repeatCount = _count * _daily;
			}	
				
			if(!_timer.running)
			{
				_timer.start();
			}
		}
		
		/**
		 * 定时器触发间隔 
		 * @param timer
		 * 
		 */
		private function onTimerHandler(timer:SecTimer):void
		{
			_currentCount--;
			setText();
		}
		
		/**
		 * 定时器完成 
		 * @param timer
		 * 
		 */
		private function onTimerComHandler(timer:SecTimer):void
		{
			if(_callBack != null)
			{
				_callBack();
			}
			hide();
		}
		
		/**
		 * 设置文字 
		 * 
		 */
		private function setText():void
		{
			var infos:Array = _str.split("n");
			
			var color:String = "#66FF33"
			if(_currentCount >= _count * 2 / 3)
			{
				color = "#66FF33";
			}
			else if(_currentCount <= _count / 3)
			{
				color = "#FF0000";
			}
			else
			{
				color = "#E46C0A";
			}
			
			_wordTxt.htmlText = HTMLUtil.addColor(infos[0] + HTMLUtil.addColor(_currentCount.toString(),color) + infos[1],"#ffc000");
		}
		
		/**
		 * 显示消息 
		 * @param str 内容
		 * @param daily 计时间隔
		 * @param count 重复次数
		 * 
		 */
		public function show(str:String,daily:int,count:int,callBack:Function=null):void
		{
			_str = str;
			_daily = daily;
			_count = count;
			_currentCount = count;
			_callBack = callBack;

			stopTimer();
			
			if(!_wordTxt)
			{
				_wordTxt = new TextField();
				_wordTxt.autoSize = TextFieldAutoSize.CENTER;
				_wordTxt.defaultTextFormat = new GTextFormat(FontUtil.xingkaiName,24,0xff0000,true,null,null,null,TextFormatAlign.CENTER);
				_wordTxt.filters = [FilterConst.nameGlowFilter];
				_wordTxt.selectable = false;
				_wordTxt.mouseEnabled = false;
				_wordTxt.width = 1000;
				_wordTxt.height = 100;
			}
			
			if(_wordTxt.parent == null)
			{
				LayerManager.windowLayer.addChild(_wordTxt);
			}
			
			setText();
			
			stageResize();
			
			startTimer();
		}
		
		/**
		 * 隐藏 
		 * 
		 */
		public function hide():void
		{
			if(_wordTxt && _wordTxt.parent != null)
			{
				LayerManager.windowLayer.removeChild(_wordTxt);
			}
			
			stopTimer();
		}
		
		/**
		 * 舞台大小改变 
		 * 
		 */
		public function stageResize():void
		{
			if(_wordTxt && _wordTxt.parent)
			{
				_wordTxt.x = (Global.stage.stageWidth - _wordTxt.textWidth) / 2;
				_wordTxt.y = Global.stage.stageHeight/2 - (Global.stage.stageHeight / 2 - _wordTxt.textHeight) / 2;
			}
		}
	}
}