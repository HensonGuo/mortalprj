/**
 * @date 2011-5-6 下午02:48:35
 * @author  宋立坤
 * 
 */  
package mortal.game.manager.item
{
	import com.gengine.global.Global;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mortal.component.gconst.FilterConst;
	
	public class LineBox extends Sprite
	{
		private var _lineLays:Array = [];//画线的层
		private var _lineNum:int;//线条种类数量
		private var _currentNum:int;//当前线条索引
		private var _refreshStep:int;//刷新频率 帧频
		private var _frameCount:int;//帧频计数
		private var _currentLine:Sprite;//当前线条
		private var _thumbParent:Sprite = new Sprite();
		
		public function LineBox()
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.cacheAsBitmap = true;
		}
		
		/**
		 * 更新线条 
		 * @param w 宽
		 * @param h 高
		 * @param step 更新频率 秒
		 * @param border 线条边框
		 * @param colors 线条变化颜色
		 * @param alpha 线条透明度
		 * 
		 */
		public function updateLine(w:int,h:int,colors:Array,step:Number=0.5,border:Number=1,palpha:Number=1):void
		{
			dispose();
			
			_refreshStep = step * Global.stage.frameRate;
			
			var index:int;
			var length:int = colors.length;
			var lineSprite:Sprite;
			var color:uint;
			while(index < length)
			{
				color = colors[index];
				lineSprite = new Sprite();
				lineSprite.graphics.lineStyle(border,color,palpha);
				lineSprite.graphics.drawRect(0,0,w,h);
				lineSprite.graphics.endFill();
				lineSprite.filters = [FilterConst.colorGlowFilter(color)];
				_lineLays.push(lineSprite);
				index++;
			}
			_lineNum = _lineLays.length;
			
			if(_lineNum == 1)//一种颜色
			{
				this.addChild(_lineLays[0]);
			}
			else if(_lineNum > 1 && _refreshStep > 0)
			{
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		/**
		 * 帧频 
		 * @param event
		 * 
		 */
		private function onEnterFrame(event:Event):void
		{
			if(_frameCount % _refreshStep == 0)//刷新频率到了
			{
				if(_currentLine && this.contains(_currentLine))
				{
					removeChild(_currentLine);
				}
				_currentLine = _lineLays[_currentNum];
				addChild(_currentLine);
				
				_currentNum++;
				
				if(_currentNum == _lineNum)
				{
					_frameCount = 0;
					_currentNum = 0;
				}
			}
			_frameCount++;
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			if(this.parent != _thumbParent)
			{
				_thumbParent.addChild(this);
			}
			
			_currentNum = 0;
			_frameCount = 0;
			_refreshStep = 0;
			_lineNum = 0;
			_lineLays.splice(0);
			
			if(_currentLine)
			{
				if(_currentLine.parent)
				{
					removeChild(_currentLine);
				}
				_currentLine.filters = null;
				_currentLine = null;
			}
			
			var childIns:Sprite;
			while(numChildren > 0)
			{
				childIns = this.removeChildAt(0) as Sprite;
				childIns = null;
			}
			this.x = 0;
			this.y = 0;
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
	}
}