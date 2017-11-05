/**
 * @date	
 * @author  黄春豪
 * 
 */	
package mortal.game.view.msgbroad
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.component.gconst.FilterConst;
	
	public class IssmNoticItem extends Sprite
	{
		private var _textField:TextField;
		private var _timerKey:int;
		private var _inTween:TweenMax;
		private var _outTween:TweenMax;
		private var _endFun:Function;
		
		public function IssmNoticItem()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			_textField = new TextField();
			_textField.selectable = false;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.width = 500;
			_textField.filters = [FilterConst.nameGlowFilter];
			var tf:TextFormat = new GTextFormat("",14,0xffff00,true,null,null,null,null,TextFormatAlign.CENTER);
			_textField.defaultTextFormat = tf;
			_textField.autoSize = TextFieldAutoSize.CENTER;
			addChild(_textField);
		}
		
		/**
		 * 淡入缓动播放完 
		 * 
		 */
		private function onInEnd():void
		{
			_timerKey = setTimeout(timerOutHandler,60000);
		}
		
		/**
		 * 淡出缓动播放完 
		 * 
		 */
		private function onOutEnd():void
		{
			if(_endFun != null)
			{
				_endFun.call(this,this);
			}
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function timerOutHandler():void
		{
			_outTween = TweenMax.to(_textField,0.3,{alpha:0,onComplete:onOutEnd});
		}
		
		/**
		 * 更新
		 * @param str
		 * @param endFun
		 * @param easeIn
		 * 
		 */
		public function updateData(str:String,endFun:Function=null,easeIn:Boolean=true):void
		{
			_textField.htmlText = HTMLUtil.addColor(str,"#ffff00");
			_textField.height = _textField.textHeight;
			//_endFun = endFun;
			if(easeIn)
			{
				_textField.alpha = 0;
				_textField.y = 20;
				_inTween = TweenMax.to(_textField,0.3,{alpha:1,y:0,onComplete:onInEnd});
			}
			else
			{
				_textField.alpha = 1;
				_textField.y = 0;
				onInEnd();
			}
		}
		
		/**
		 * 停止淡入缓动 
		 * 
		 */
		public function killInEase():void
		{
			if(_inTween && _inTween.active)
			{
				_textField.y = 0;
				_textField.alpha = 1;
				_inTween.kill();
				onInEnd();
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_endFun = null;
			clearTimeout(_timerKey);
			
			if(_inTween && _inTween.active)
			{
				_inTween.kill();
			}
			else if(_outTween && _outTween.active)
			{
				_outTween.kill();
			}
			
			_textField.alpha = 1;
			_textField.y = 0;
		}
		
		override public function get height():Number
		{
			return _textField.textHeight;
		}
		
		override public function get width():Number
		{
			return _textField.width;
		}
	}
}