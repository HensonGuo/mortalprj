/**
 * 2014-4-10
 * @author chenriji
 **/
package mortal.game.view.common.display
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.UIFactory;
	
	public class BitmapNumberText extends GSprite
	{
		private var _text:String;
		private var _urlName:String;
		private var _curBmps:Array = [];
		private var _needUpdate:Boolean = false;
		
		private var _cellWidth:int = 16;
		private var _cellHeight:int = 20;
		private var _gap:int = 2;
		
		public var picNum:int = 13;
		
		private static var _bmpds:Dictionary = new Dictionary();
		private static const  charIndex:Object = {"0":0, "1":1, "2":2, "3":3, "4":4, "5":5,
			"6":6, "7":7, "8":8, "9":9, "(":10, ")":11, "-":12, "+":13,"/":14
			};
		
		public function BitmapNumberText()
		{
			super();
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			delNotUse(_curBmps, 0);
			_curBmps = [];
		}
		
		public function set text(value:String):void
		{
			_text = value;
			_needUpdate = true;
			updateText();
		}
		
		public override function get width():Number
		{
			if(_text == null || _text == "")
			{
				return super.width;
			}
			var len:int = _text.length;
			return (len * _cellWidth + (len - 1)*_gap);
		}
		
		public override function get height():Number
		{
			return _cellHeight;
		}
		
		public function setSytleName(url:String, cellWidth:int, cellHeight:int, hGap:int=2):void
		{
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_gap = hGap;
			_urlName = url;
			if(_bmpds[url] != null)
			{
				updateText();
				return;
			}
			
			LoaderManager.instance.load(_urlName, onLoaded);
		}
		
		private function onLoaded(info:ImageInfo):void
		{
			if(_urlName != null && _bmpds[_urlName] != null)
			{
				updateText();
				return;
			}
			initBmps(info.bitmapData);
			updateText();
		}
		
		public function initBmps(bmp:BitmapData):void
		{
			var bmps:Array = [];
			_bmpds[_urlName] = bmps;
			for(var i:int = 0; i <= picNum; i++)  //本来是14,chageByTangkaixin
			{
				var data:BitmapData = new BitmapData(_cellWidth, _cellHeight, true, 0);
				data.draw(bmp, new Matrix(1, 0, 0, 1, -i*_cellWidth));
				bmps.push(data);
			}
		}
		
		private function updateText():void
		{
			if(_bmpds[_urlName] == null || !_needUpdate)
			{
				return;
			}
			_needUpdate = false;
			if(_text == null || _text == "")
			{
				delNotUse(_curBmps, 0);
				return;
			}
			for(var i:int = 0; i < _text.length; i++)
			{
				var str:String = _text.charAt(i);
				var data:BitmapData = getBitmapData(str);
				if(data == null)
				{
					continue;
				}
				var bmp:GBitmap = _curBmps[i];
				if(bmp == null)
				{
					bmp = UIFactory.gBitmap("", i * (_cellWidth + _gap), 0, this);
					_curBmps.push(bmp);
				}
				bmp.bitmapData = data;
			}
			delNotUse(_curBmps, _text.length);
		}
		
		private function getBitmapData(str:String):BitmapData
		{
			if(!charIndex.hasOwnProperty(str))
			{
				return null;
			}
			var index:int = int(charIndex[str]);
			return BitmapData(_bmpds[_urlName][index]);
		}
		
		private function delNotUse(arr:Array, usedNum:int):void
		{
			if(arr.length <= usedNum)
			{
				return;
			}
			var tmp:int = usedNum;
			for(var i:int = usedNum; i < arr.length; i++)
			{
				var p:GBitmap = arr[i];
				p.dispose(true);
			}
			if(tmp < i && arr.length >= tmp)
			{
				arr.splice(tmp);
			}
		}
	}
}