package mortal.game.manager.msgTip
{
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
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
	
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.LayerManager;

	public class MsgFloatWordImpl
	{
		private var _wordTxt:TextField;
		private var _tweenIn:TweenMax;
		
		public function MsgFloatWordImpl()
		{
		}
		
		/**
		 * 飘字提示 
		 * @param word
		 * 
		 */
		public function showWord(word:String):void
		{
			dispose();
			
			if(!_wordTxt)
			{
				_wordTxt = new TextField();
				_wordTxt.autoSize = TextFieldAutoSize.CENTER;
				_wordTxt.defaultTextFormat = new GTextFormat(FontUtil.xingkaiName,36,0xffc000,null,null,null,null,TextFormatAlign.CENTER);
				_wordTxt.filters = [FilterConst.nameGlowFilter];
				_wordTxt.selectable = false;
				_wordTxt.mouseEnabled = false;
				_wordTxt.width = 1000;
				_wordTxt.height = 100;
			}
			
			if(_wordTxt.parent == null)
			{
				LayerManager.msgTipLayer.addChild(_wordTxt);
			}
			
			_wordTxt.htmlText = HTMLUtil.addColor(word,"#ffc000");
			_wordTxt.alpha = 0;
			_tweenIn = TweenMax.to(_wordTxt,1,{alpha:1,ease:Quint.easeIn});
			
			stageResize();
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			if(_tweenIn && _tweenIn.active)
			{
				_tweenIn.kill();
			}
			
			if(_wordTxt)
			{
				_wordTxt.text = "";
				if(_wordTxt.parent)
				{
					_wordTxt.parent.removeChild(_wordTxt);
				}
			}
		
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
				_wordTxt.y = (Global.stage.stageHeight - _wordTxt.textHeight) / 2 - 50;
			}
		}
	}
}