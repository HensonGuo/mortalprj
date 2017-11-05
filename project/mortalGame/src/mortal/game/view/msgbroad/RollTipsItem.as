package mortal.game.view.msgbroad
{
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.MsgManager;
	
	/**
	 * 白色滚动飘字 
	 * @author 宋立坤
	 * 
	 */
	public class RollTipsItem extends Sprite
	{
		private var _bmp:Bitmap;
		private var _bmpd:BitmapData;
		
		private var _textField:TextField;
		private var _width:int;
		
		private var _endCall:Function;		//回调
		private var _timeKey:uint;
		private var _timeIn:Boolean;
		
		public function RollTipsItem(width:int = 320)
		{
			super();
			_width = width;
			initUI();
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function initUI():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			_bmp = new Bitmap();
			addChild(_bmp);
			
			_textField = new TextField();
			_textField.selectable = false;
			_textField.width = _width;
			_textField.height = 24;
			_textField.filters = [FilterConst.rollTipsFilter,FilterConst.rollTipsFilter2];
			var tf:TextFormat = new GTextFormat(FontUtil.songtiName,14,0xB72531,true,null,null,null,null,TextFormatAlign.LEFT);
			tf.letterSpacing = 2;
			_textField.defaultTextFormat = tf;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = true;
			_textField.wordWrap = true;
		}
		
		/**
		 * 更新数据 
		 * @param str
		 * @param endCall
		 * @param msgLength
		 * 
		 */
		public function updateData(str:String,endCall:Function):void
		{
			_timeIn = false;
			_endCall = endCall;
			
			_textField.width = Global.stage.stageWidth / 2 - 120;
			_textField.htmlText = HTMLUtil.addColor(str,"#ffffff");
			_textField.y = 0;
			_textField.alpha = 1;
			
			if(_bmpd)
			{
				_bmpd.dispose();
				_bmpd = null;
			}
			_bmpd = new BitmapData(_textField.textWidth,_textField.textHeight+2,true,0);
			_bmpd.draw(_textField);
			_bmp.bitmapData = _bmpd;
			_bmp.y = 0;
			_bmp.alpha = 0;
			
			TweenMax.to(_bmp,1.5,{alpha:1.2,frameInterval:2,y:-100,ease:Linear.easeInOut(30,400,3,40),onComplete:onInEnd});
		}
		
		/**
		 * 入场完毕 
		 * 
		 */
		private function onInEnd():void
		{
			if(MsgManager.rollMsgLength > 1)//还有消息
			{
				onTimeOut();
			}
			else
			{
				_timeKey = setTimeout(onTimeOut,1000);
				_timeIn = true;
			}
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function onTimeOut():void
		{
			_timeIn = false;
			TweenMax.to(_bmp,0.5,{alpha:0,y:-130,ease:Linear.easeOut(30,400,3,40),onComplete:onOutEnd});
		}
		
		/**
		 * 退场完毕 
		 * 
		 */
		private function onOutEnd():void
		{
			if(_endCall != null)
			{
				_endCall.call(this,this);
			}
		}
		
		/**
		 * 结束停留 
		 * 
		 */
		public function clearTimeOut():void
		{
			if(_timeIn)
			{
				_timeIn = false;
				clearTimeout(_timeKey);
				onTimeOut();
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			if(_bmpd)
			{
				_bmpd.dispose();
				_bmpd = null;
			}
			_textField.text = "";
			_bmp.y = 0;
			_bmp.alpha = 1;
			_endCall = null;
		}
	}
}