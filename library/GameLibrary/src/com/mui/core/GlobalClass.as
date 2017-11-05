package com.mui.core
{
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GUIComponent;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class GlobalClass
	{
		public static var libaray:Library = new Library("global");
		
		private static var _bitmapdataMap:Dictionary = new Dictionary();
		private static var _colorMap:Dictionary = new Dictionary();
		
		public function GlobalClass()
		{
			
		}
		
		/**
		 * 是否有这个资源 
		 * @param className
		 * 
		 */		
		public static function hasRes(fullClassName:String):Boolean
		{
			return libaray.hasDefinition(fullClassName);
		}
		
		public static function getInstance( className:String ):*
		{
			var cls:Class = libaray.getDefinition(className);
			return new cls();
		}
		
		public static function getClass(fullClassName:String):Class
		{
			return libaray.getDefinition(fullClassName);
		}
		
		public static function getBitmapData(fullClassName:String):BitmapData
		{
			if( !(fullClassName in _bitmapdataMap) )
			{
				_bitmapdataMap[fullClassName] = getBitmapdataImpl(fullClassName);
			}
			return _bitmapdataMap[fullClassName];
		}
		
		public static function getBitmapDataByColor(color:int):BitmapData
		{
			if( !(color in _colorMap) )
			{
				_colorMap[color] = new BitmapData(10,10,true,color);
			}
			return _colorMap[color];
		}
		
		/**
		 * 添加图片 
		 * @param fullClassName
		 * @param bitmapData
		 * 
		 */
		public static function addBitmapData(fullClassName:String,bitmapData:BitmapData):void
		{
			if( !(fullClassName in _bitmapdataMap) )
			{
				_bitmapdataMap[fullClassName] = bitmapData;
			}
		}
		
		public static function getBitmap(fullClassName:String):GBitmap
		{
			var bmd:BitmapData = getBitmapData(fullClassName);
			if(bmd != null)
			{
				var bmp:GBitmap = UICompomentPool.getUICompoment(GBitmap) as GBitmap;
				bmp.bitmapData = bmd;
				return bmp;
			}
			return null;
		}
		
		
		public static function getScaleBitmap( fullClassName:String ,scale9Grid:Rectangle=null):ScaleBitmap
		{
			var bmd:BitmapData = getBitmapData(fullClassName);
			if(bmd != null)
			{
				var sb:ScaleBitmap = UICompomentPool.getUICompoment(ScaleBitmap) as ScaleBitmap;
				sb.bitmapData = bmd.clone();
				sb.createDisposeChildren();
				sb.scale9Grid = scale9Grid;
				return sb;
			}
			return null;
		}
		
		private static function getBitmapdataImpl( fullClassName:String ):BitmapData
		{
			//资源里面取图片
			var assetClass:Class = getClass(fullClassName);
			if(assetClass != null)
			{
				return new assetClass(0,0) as BitmapData;
			}
			return null;
		}
		
	}
}