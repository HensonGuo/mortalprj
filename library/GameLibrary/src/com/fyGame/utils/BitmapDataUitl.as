package com.fyGame.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapDataUitl
	{
		public function BitmapDataUitl()
		{

		}


		/**
		 * 替换位图指定颜色值;
		 * @param bitmapData 位图;
		 * @param color 需要替换的颜色(ARBG);
		 * @param repColor 替换的颜色(ARBG);
		 * @param mask 用于隔离颜色成分的遮罩(ARBG 0x00FF0000);
		 */
		public static function replaceColor(bitmapData:BitmapData, color:uint, repColor:uint, mask:uint=0x00FFFFFF):void
		{
			if (bitmapData == null || bitmapData.width < 1)
			{
				return;
			}
			bitmapData.threshold(bitmapData, bitmapData.rect, new Point(), "==", color, repColor, mask, true);
		}

		/**
		 * 获取图片真实大小（去除透明部分）
		 * @param bitmapData 位图;
		 * @return Rectangle
		 */
		public static function getRealImageRect(bitmapData:BitmapData):Rectangle
		{
			if (bitmapData == null || bitmapData.width < 1)
			{
				return new Rectangle();
			}
			return bitmapData.getColorBoundsRect(0xFF000000, 0, false);
		}

		/**
		 * 是否空图片(去除透明部分)
		 * @param bitmapData 位图;
		 * @return
		 */
		public static function isEmptyImage(bitmapData:BitmapData):Boolean
		{
			if (bitmapData == null || bitmapData.width < 1)
			{
				return false;
			}
			return getRealImageRect(bitmapData).equals(new Rectangle());
		}

		/**
		 * 向右翻转
		 * @param bmp
		 * @return
		 *
		 */
		public static function scaleRight(bmp:BitmapData):BitmapData
		{
			var m:Matrix=new Matrix();
			m.rotate(Math.PI);
			m.translate(bmp.height, 0);
			var bd:BitmapData=new BitmapData(bmp.height, bmp.width, true, 0);
			bd.draw(bmp, m);
			return bd;
		}

		/**
		 * 像左翻转90读
		 * @param bmp
		 * @return
		 *
		 */
		public static function scaleLeft(bmp:BitmapData):BitmapData
		{
			/*var m:Matrix = new Matrix();
			m.rotate(-Math.PI);
			m.translate(0,bmp.width);
			var bd:BitmapData = new BitmapData(bmp.height, bmp.width,true,0);
			bd.draw(bmp,m);*/
			return rightandleft(bmp);
		}

		private static function rightandleft(bt:BitmapData):BitmapData
		{
			var bmd:BitmapData=new BitmapData(bt.width, bt.height, true, 0x00000000);
			for (var yy:int=0; yy < bt.height; yy++)
			{
				for (var xx:int=0; xx < bt.width; xx++)
				{
					bmd.setPixel32(bt.width - xx - 1, yy, bt.getPixel32(xx, yy));
				}
			}
			return bmd;
		}
	}
}
