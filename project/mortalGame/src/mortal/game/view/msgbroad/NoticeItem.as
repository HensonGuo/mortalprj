/**
 * @date	2011-3-18 下午03:02:49
 * @author  宋立坤
 * 
 */	
package mortal.game.view.msgbroad
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	
	public class NoticeItem extends Sprite
	{
		private const WIDTH:int = 270;
		private var _bmpDict:Array = [];
		private var _lineDict:Array = [];
		private var _widthDict:Array = [];
		
		private var _textField:TextField;
		private var _matix:Matrix = new Matrix();
		
		private var _height:int;
		private var _line:int;
		private var _timerKey:int;
		private var _outTween:TweenMax;
		private var _endFun:Function;
		private var _hideCallBack:Function;
		private var _hideIng:Boolean;
		public var disposed:Boolean;
		
		public function NoticeItem()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			cacheAsBitmap = true;
			
			_textField = new TextField();
			_textField.selectable = false;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.width = WIDTH;
//			_textField.filters = [FilterConst.noticeItemFilter2,FilterConst.noticeItemFilter];
			var tf:TextFormat = new GTextFormat(FontUtil.songtiName,14,0xffff00,false,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
			tf.letterSpacing = 2;
			_textField.defaultTextFormat = tf;
			_textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * 淡入缓动播放完 
		 * 
		 */
		private function onInEnd():void
		{
			_timerKey = setTimeout(timerOutHandler,3000);
//			_timerKey = setTimeout(onOutEnd,3000);
		}
		
		/**
		 * 淡出缓动播放完 
		 * 
		 */
		public function onOutEnd():void
		{
			if(_endFun != null)
			{
				_endFun.call(this,this);
			}
		}
		
		/**
		 * 消失缓动播放完 
		 * 
		 */
		private function onHideEnd():void
		{
			_hideIng = false;
			if(_hideCallBack != null)
			{
				_hideCallBack.call(this,this);
			}
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function timerOutHandler():void
		{
			var index:int;
			var bmp:Bitmap;
			while(index < numChildren)
			{
				bmp = _bmpDict[index];
				if(index == 0)
				{
					_outTween = TweenMax.to(bmp,0.2,{alpha:0.2,onComplete:onOutEnd});
				}
				else
				{
					_outTween = TweenMax.to(bmp,0.2,{alpha:0.2});
				}
				index++;
			}
		}
		
		/**
		 * 更新
		 * @param str
		 * @param endFun
		 * @param inDis
		 * @param easeIn
		 * 
		 */
		public function updateData(str:String,endFun:Function,inDis:int=70,easeIn:Boolean=true):void
		{
			disposed = false;
			
			_line = 0;
			_height = 0;
			_matix.ty = 0;
			_lineDict.splice(0);
			_widthDict.splice(0);
			
			_textField.htmlText = HTMLUtil.addColor(str,"#ffff00");
			_textField.height = _textField.textHeight;

			var index:int;
			var length:int = _textField.numLines;
			var bmp:Bitmap;
			while(index < length)
			{
				bmp = getBmpByLine(index);
				addChild(bmp);
				index++;
			}
			
			resetPosx();
			
			_endFun = endFun;
			onInEnd();
		}
		
		private function getBmpByLine(index:int):Bitmap
		{
			var lineMetrics:TextLineMetrics = getLineMetrics(index);
			var bmp:Bitmap = _bmpDict[index];
			if(!bmp)
			{
				bmp = _bmpDict[index] = new Bitmap();
				bmp.filters = [FilterConst.noticeItemFilter2,FilterConst.noticeItemFilter];
			}
			bmp.alpha = 1;
			bmp.bitmapData = getBmpdByLine(index,lineMetrics);
			
			if(index % 3 == 0)
			{
				_line++;
			}
			
			var preLineMetrics:TextLineMetrics;
			if(index != 0)
			{
				preLineMetrics = getLineMetrics(index - 1);
			}
			bmp.x = getLineSumWidth(_line);
			if(preLineMetrics)
			{
				if(_line > 1)
				{
					bmp.y = (_line-1) * preLineMetrics.height;
				}
				else
				{
					bmp.y = 0;
				}
			}
			else
			{
				bmp.y = 0;
			}
			
			if(!_lineDict[_line-1])
			{
				_lineDict[_line-1] = [];
			}
			_lineDict[_line-1].push(bmp);
			if(!_widthDict[_line-1])
			{
				_widthDict[_line-1] = 0;
			}
			_widthDict[_line-1] = _widthDict[_line-1] + lineMetrics.width;
			
			return bmp;
		}
		
		private function getBmpdByLine(index:int,lineMetrics:TextLineMetrics):BitmapData
		{
			var lineHeight:int = lineMetrics.height;
			var lineWidth:int = lineMetrics.width;
			_matix.ty = -index * lineHeight;
			var bmpd:BitmapData = new BitmapData(lineWidth,lineHeight,true,0x00000000);
			bmpd.draw(_textField,_matix);
			return bmpd;
		}
		
		private function getLineMetrics(index:int):TextLineMetrics
		{
			var tme:TextLineMetrics;
			try
			{
				tme = _textField.getLineMetrics(index);
			}
			catch(e:Error)
			{
				tme = new TextLineMetrics(0,20,20,0,0,0);
			}
			return tme;
		}
		
		private function resetPosx():void
		{
			var px:int;
			var index:int;
			var bmpIndex:int;
			var bmpLength:int;
			var bmps:Array;
			var bmp:Bitmap;
			while(index < _line)
			{
				px = (this.width - _widthDict[index]) / 2;
				bmps = _lineDict[index];
				bmpLength = bmps.length;
				bmpIndex = 0;
				while(bmpIndex < bmpLength)
				{
					bmp = bmps[bmpIndex]; 
					bmp.x += px;
					bmpIndex++;
				}
				index++;
			}
		}
		
		/**
		 * 返回line的总width 
		 * @param index
		 * @return 
		 * 
		 */
		private function getLineSumWidth(line:int):int
		{
			if(_widthDict.length >= line)
			{
				return _widthDict[line-1];
			}
			return 0;
		}
		
		/**
		 * 消失的滚动效果 
		 * @param callBack
		 * 
		 */
		public function easeHide(callBack:Function):void
		{
			_hideIng = true;
			_hideCallBack = callBack;
			onHideEnd();
		}
		
		/**
		 * 停止淡入缓动 
		 * 
		 */
		public function killInEase():void
		{
			onInEnd();
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_textField.text = "";
			_hideCallBack = null;
			_hideIng = false;
			_endFun = null;
			clearTimeout(_timerKey);
			if(_outTween && _outTween.active)
			{
				_outTween.kill();
			}
			
			var bmp:Bitmap;
			while(0 < numChildren)
			{
				bmp = removeChildAt(0) as Bitmap;
				bmp.bitmapData.dispose();
				bmp.bitmapData = null;
			}
			disposed = true;
		}
		
		public function updatePosY(value:int):void
		{
			this.y = value;
		}
		
		public function get hideIng():Boolean
		{
			return _hideIng;
		}
		
		override public function get height():Number
		{
			if(_height == 0)
			{
				_height = _line * 20;
			}
			return _height;
		}
		
		override public function get width():Number
		{
			return 810;
		}
	}
}