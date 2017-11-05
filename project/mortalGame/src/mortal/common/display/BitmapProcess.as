/**
 * 图片对应的进度条 
 * heartspeak
 */
package mortal.common.display
{
	import com.gengine.resource.LoaderManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class BitmapProcess extends Sprite
	{
		public function BitmapProcess(bmpUrl:String = "")
		{
			init();
			if(bmpUrl)
			{
				setBimapUrl(bmpUrl);
			}
		}
		
		private var _bmpdSource:BitmapData;
		private var _bmp:Bitmap;
		private var _bmpdOver:BitmapData;
		private var _isLoadOverData:Boolean = false;
		private var _per:Number = 0;
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void
		{
			this.mouseEnabled = false;
			_bmp = new Bitmap();
			this.addChild(_bmp);
		}
		
		/**
		 * 设置资源路径 
		 * @param bgUrl
		 * @param overUrl
		 * 
		 */
		public function setBimapUrl(url:String):void
		{
			LoaderManager.instance.load(url,onLoaded);
		}
		
		/**
		 * 设置百分比 
		 * @param per
		 * 
		 */
		public function setPer(per:Number):void
		{
			_per = per;
			if(_isLoadOverData)
			{
				draw();
			}
		}
		
		/**
		 * 加载资源成功 
		 * 
		 */
		private function onLoaded(info:*):void
		{
			_bmpdSource = (info.bitmapData as BitmapData);
			_isLoadOverData = true;
			draw();
		}
		
		/**
		 * 绘制BitmapData
		 * 
		 */
		private function draw():void
		{
			var perWidth:Number = 0;
			_bmp.bitmapData = null;
			if(_bmpdOver)
			{
				_bmpdOver.dispose();
			}
			if(_per > 0)
			{
				perWidth = _per * _bmpdSource.width;
				if(perWidth >= 1)
				{
					_bmpdOver = new BitmapData(perWidth,_bmpdSource.height,true,0x00ffffff);
					_bmpdOver.draw(_bmpdSource,null,null,null,new Rectangle(0,0,perWidth,_bmpdSource.height));
					_bmp.bitmapData = _bmpdOver;
				}
			}
		}
	}
}