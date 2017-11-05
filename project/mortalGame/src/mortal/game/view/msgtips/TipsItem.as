/**
 * @date	2011-3-22 下午02:53:09
 * @author  宋立坤
 * 
 */	
package mortal.game.view.msgtips
{
	import com.gengine.utils.HTMLUtil;
	import com.greensock.TweenMax;
	
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
	
	public class TipsItem extends Sprite
	{
		private var _tipTxt:TextField;
		private var _timerKey:uint;
		private var _hideFun:Function;
		private var _hideAble:Boolean;
		private var _colorUpdated:Boolean;
		
		public function TipsItem()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			_tipTxt = new TextField();
			_tipTxt.multiline = true;
			_tipTxt.autoSize = TextFieldAutoSize.LEFT;
			_tipTxt.wordWrap = true;
			_tipTxt.width = 150;
			_tipTxt.selectable = false;
			_tipTxt.mouseEnabled = false;
			_tipTxt.textColor = 0xe8e8e8;
			_tipTxt.filters = [FilterConst.nameGlowFilter];
			addChild(_tipTxt);
		}
		
		public function get hideAble():Boolean
		{
			return _hideAble;
		}
		
		public function get colorUpdated():Boolean
		{
			return _colorUpdated;
		}
		
		/**
		 * 消失鸟 
		 * 
		 */
		private function onTimerOut():void
		{
			_hideAble = false;
			if(_hideFun != null)
			{
				_hideFun.call(this,this);
			}
		}
		
		/**
		 * 更新显示 
		 * @param str
		 * @param hideAble 是不是会消失
		 * @param hideDelay 消失时间 毫秒
		 * @param hideFun  消失的回调函数
		 * 
		 */
		public function updateData(str:String,color:String="#ffff00",delay:int=0,hideFun:Function=null):void
		{
			_colorUpdated = false;
			_tipTxt.htmlText = HTMLUtil.addColor(str,color);
			_hideAble = (delay != 0);
			if(hideAble)
			{
				_timerKey = setTimeout(onTimerOut,delay);
			}
		}
		
		/**
		 * 更新颜色 
		 * @param color
		 * 
		 */
		public function updateColor(color:String = "#e8e8e8"):void
		{
			var str:String = HTMLUtil.removeHtml(_tipTxt.htmlText);
			_tipTxt.text = str;
			_colorUpdated = true;
		}
		
		private var _easeIn:TweenMax;
		
		/**
		 * 淡入 
		 * 
		 */
		public function easeIn():void
		{
			_tipTxt.y = 15;
			_easeIn = TweenMax.to(_tipTxt,0.5,{y:0,onComplete:onEaseInEnd});
		}
		
		/**
		 * 停止淡入 
		 * 
		 */
		public function killEaseIn():void
		{
			_tipTxt.y = 0;
			if(_easeIn && _easeIn.active)
			{
				_easeIn.kill();
			}
		}
		
		/**
		 * 进入完成 
		 * 
		 */
		private function onEaseInEnd():void
		{
			
		}
		
		/**
		 * 销毁 
		 * 
		 */
		public function dispose():void
		{
			killEaseIn();
			_colorUpdated = false;
			_hideAble = false;
			_hideFun = null;
			clearTimeout(_timerKey);
		}
		
		override public function get height():Number
		{
			if(_tipTxt.textHeight > 50)
			{
				return 15;
			}
			return _tipTxt.textHeight; 
		}
	}
}