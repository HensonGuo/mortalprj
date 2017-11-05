package mortal.game.manager.msgTip
{
	import com.gengine.utils.HTMLUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.LayerManager;

	public class MsgGuideTipsImpl extends Sprite
	{
		private var _text:TextField;
		private var _timeKey:uint;
		
		public function MsgGuideTipsImpl()
		{
			super();
			cacheAsBitmap = true;
			mouseEnabled = false;
			mouseChildren = false;
			tabEnabled = false;
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function initText():void
		{
			_text = new TextField();
			_text.defaultTextFormat = new GTextFormat("",14,0xF6984F,true,null,null,null,null,TextFormatAlign.LEFT);
			_text.multiline = true;
			_text.wordWrap = true;
			_text.width = 200;
			_text.x = 10;
			_text.y = 10;
			_text.filters = [FilterConst.nameGlowFilter];
			_text.mouseEnabled = false;
			addChild(_text);
		}
		
		/**
		 * 绘制线圈 
		 * 
		 */
		private function drawLineBox():void
		{
			graphics.clear();
			graphics.lineStyle(1,0xF6984F);
			graphics.beginFill(0,1);
			graphics.drawRect(0,0,_text.textWidth + 20,_text.textHeight + 20);
			graphics.endFill();
		}
		
		/**
		 * 显示时间到 
		 * 
		 */
		private function onTimeOut():void
		{
			hide();
		}
		
		/**
		 * 显示 
		 * @param str
		 * @param px
		 * @param py
		 * @param layer
		 * @param deley
		 * 
		 */
		public function show(str:String,px:int,py:int,layer:DisplayObjectContainer = null,deley:int=0):void
		{
			if(!_text)
			{
				initText();
			}
			
			if(layer == null)
			{
				layer = LayerManager.guideLayer;
			}
			
			_text.htmlText = HTMLUtil.addColor(str,"#F6984F");
			drawLineBox();
			
			this.x = px;
			this.y = py;
			layer.addChild(this);
			
			clearTimeout(_timeKey);
			if(deley > 0)
			{
				_timeKey = setTimeout(onTimeOut,deley);
			}
		}
		
		/**
		 * 隐藏 
		 * 
		 */
		public function hide():void
		{
			graphics.clear();
			clearTimeout(_timeKey);
			
			if(_text)
			{
				_text.text = "";
			}
			
			if(this.parent)
			{
				this.parent.removeChild(this);	
			}
		}
	}
}