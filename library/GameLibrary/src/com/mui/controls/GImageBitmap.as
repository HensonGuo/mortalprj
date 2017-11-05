package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.resource.LoaderManager;
	import com.mui.core.IFrUI;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	public class GImageBitmap extends Bitmap implements IDispose
	{
		private var _imgUrl:String;
		
		private var _loadPriority:int = 3;
		
		//后缀数组
		public static var _arySuffix:Array = [".png",".jpg",".jpeg",".swf"];
		
		public function GImageBitmap(posX:int=0,posY:int=0)
		{
			x = posX;
			y = posY;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		/**
		 * 添加到舞台 
		 * @param e
		 * 
		 */		
		private function onAddToStage(e:Event):void
		{
			
		}
		
		/**
		 * 移除舞台 
		 * @param e
		 * 
		 */
		private function onRemoveFromStage(e:Event):void
		{
			
		}
		
		/**
		 * 获取路径 
		 * @param imgUrl
		 * @return 
		 * 
		 */		
		public static function getUrl(imgUrl:String):String
		{
			var imgUrlLowerCase:String = imgUrl.toLocaleLowerCase();
			for each(var suffix:String in _arySuffix)
			{
				if(imgUrlLowerCase.indexOf(suffix) > 0)
				{
					return imgUrl;
				}
			}
			
			return imgUrl + ".swf";
		}
		
		/**
		 * 设置图片路径，如果图片路径没有加后缀名，则添加.swf后缀 
		 * @param value
		 * 
		 */		
		public function set imgUrl(value:String):void
		{ 
			if(!value)
			{
				return;
			}
			_imgUrl = getUrl(value);
			setBitmapdata(_imgUrl);
		}

		public function get imgUrl():String
		{
			return _imgUrl;
		}

		protected function setBitmapdata( url:String ):void
		{
			var bitmap:Bitmap = this;
			LoaderManager.instance.load(url,function( info:* ):void
			{
				bitmap.bitmapData = info.bitmapData as BitmapData;
			},loadPriority);
		}

		public function get loadPriority():int
		{
			return _loadPriority;
		}

		public function set loadPriority(value:int):void
		{
			_loadPriority = value;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			x = 0;
			y = 0;
			_loadPriority = 3;
			bitmapData = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
			}
		}
	}
}