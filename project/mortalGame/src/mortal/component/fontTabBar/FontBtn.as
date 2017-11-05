package mortal.component.fontTabBar
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class FontBtn extends GButton
	{
		private var _bmp:Bitmap;
		
		public function FontBtn()
		{
			super();
			
			_bmp = new Bitmap();
			addChild(_bmp);
			
			label = "";
			styleName = "TabButton";
		}
		
		/**
		 * 图片下载完成 
		 * @param img
		 * 
		 */
		private function onImgLoadedHandler(img:ImageInfo):void
		{
			if(img && img.bitmapData)
			{
				_bmp.bitmapData = img.bitmapData;
				updateBtnPos();
			}
		}
		
		/**
		 * 更新图片的位置 
		 * 
		 */
		protected function updateBtnPos():void
		{
			if(_bmp && _bmp.bitmapData)
			{
				_bmp.x = (width - _bmp.bitmapData.width)/2;
				_bmp.y = (height - _bmp.bitmapData.height)/2;
			}
		}
		
		/**
		 * 设置图片的地址 
		 * @param url
		 * 
		 */
		public function set imgUrl(url:String):void
		{
			if(GlobalClass.hasRes(url))
			{
				_bmp.bitmapData = GlobalClass.getBitmapData(url);
			}
			else
			{
				LoaderManager.instance.load(url,onImgLoadedHandler);
			}
		}
		
		/**
		 * 改变大小  
		 * @param w
		 * @param h
		 * @return 
		 * 
		 */
		public function updateBtnSize(w:int,h:int):void
		{
			var chx:Number = (width - w)/2;
		
			if(chx != 0)
			{
				_btnx = chx;
			}
		
			x += chx;
			y += (height - h)/2;
			
			width = w;
			height = h;

			updateBtnPos();
		}
		
		private var _btnx:Number = 0;
		
		public function get btnx():Number
		{
			return _btnx;
		}
	}
}