package mortal.game.view.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ImageNum extends Sprite
	{
		private var _numBmdArray:Array;
		/**
		 *显示数字图片。
		 */		
		private var _bitmapArray:Array;
		/**
		 *数字数组。高位到低位。  
		 */		
		private var _numArray:Array;
		private var _len:int;
		
		public function ImageNum()
		{
			super();
			_bitmapArray = [];
		}

		/**
		 *数字图片。序号对应图片数字 
		 */
		public function set numBmdArray(value:Array):void
		{
			_numBmdArray = value;
		}
		
		/**
		 *更新数字 
		 * @param num
		 * 
		 */		
		public function updateNum(num:int):void
		{
			_numArray = [];
			_len = num.toString().length;
			
			var bitmap:Bitmap;
			var yu:int = num;
			var pow:int = _len - 1;
			var v:int;
			for (var i:int = 0; i < _len; i++) 
			{
				if(yu % Math.pow(10,pow) != 0)
				{
					v = int(yu / Math.pow(10,pow));
				}
				else
				{
					v = yu / Math.pow(10,pow);
				}
				_numArray.push(v);
				yu = yu % Math.pow(10,pow);
				pow--;
			}
			updateBitmap();
			
		}
		
		/**
		 *更新图片 
		 * 
		 */		
		private function updateBitmap():void
		{
			clear();
			var bitmap:Bitmap;
			var v:int;
			for (var i:int = 0; i < _len; i++) 
			{
				bitmap = _bitmapArray[i];
				if(bitmap == null)
				{
					bitmap = new Bitmap();
					_bitmapArray[i] = bitmap;
				}
				v = _numArray[i] as int;
				bitmap.bitmapData = _numBmdArray[v] as BitmapData;
				bitmap.x = i*30;
				this.addChild(bitmap);
			}
		}
		
		/**
		 *清空
		 */		
		private function clear():void
		{
			var bitmap:Bitmap;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				bitmap = this.getChildAt(i) as Bitmap;
				if(bitmap)
				{
					this.removeChild(bitmap);
				}
			}
		}
	}
}